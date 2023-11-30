<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="util.jsp" %>

<%
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("logout.jsp");
        return;
    }

    List<String> courses = new ArrayList<>();
    try(Connection con = Util.get_conn();
        PreparedStatement statement = con.prepareStatement("SELECT * FROM courses WHERE UserID = ?")){
        statement.setInt(1, userID);
        ResultSet rs = statement.executeQuery();
        while (rs.next()) {
            courses.add(rs.getString("CourseName"));
        }
    } catch (SQLException e) {
        out.println("fetch courses error: " + e);
    }

    String newCourse = request.getParameter("course");
    if (newCourse != null && !newCourse.isEmpty()) {
        try (
            Connection con = Util.get_conn();
            PreparedStatement statement = con.prepareStatement("INSERT INTO courses (UserID, CourseName) VALUES (?, ?)")){
            statement.setInt(1, userID);
            statement.setString(2, newCourse);
            statement.executeUpdate();

            response.sendRedirect("settings.jsp");
        } catch (SQLException e) {
            out.println("insert course error: " + e);
        }
    }
    // Fetch categories from the database for the specific user
    List<String> categories = new ArrayList<>();
    try {
        Connection con = Util.get_conn();
        PreparedStatement statement = con.prepareStatement("SELECT * FROM categories WHERE UserID = ?");
        statement.setInt(1, userID);
        ResultSet rs = statement.executeQuery();
        while (rs.next()) {
            categories.add(rs.getString("CategoryName"));
        }
    } catch (SQLException e) {
        out.println("fetch categories error: " + e);
    }

    // Handle category form submission
    String newCategory = request.getParameter("category");
    if (newCategory != null && !newCategory.isEmpty()) {
        try {
            Connection con = Util.get_conn();
            PreparedStatement statement = con.prepareStatement("INSERT INTO categories (UserID, CategoryName) VALUES (?, ?)");
            statement.setInt(1, userID);
            statement.setString(2, newCategory);
            statement.executeUpdate();
            // Redirect to the same page to refresh categories
            response.sendRedirect("settings.jsp");
        } catch (SQLException e) {
            out.println("insert category error: " + e);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskU Settings</title>
    <link rel="stylesheet" href="styles.css">
    <style>


      form{
        display: block;
        margin-top: 10px;
      }
      body {
        display: flex;
        flex-direction: column;
        height: 100vh;
        margin: 0;
      }

      .main-container {
        display: flex;
        flex: 1;
      }

      .tabs-container {
        width: 200px;
        background-color: #f1f1f1;
        padding: 20px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        box-sizing: border-box;
      }

      .tabs-container button {
        width: 100%;
        padding: 10px;
        margin-bottom: 10px;
        background-color: #ddd;
        border: none;
        text-align: left;
        cursor: pointer;
        color:black;
      }

      .tabs-container button:hover {
        background-color: #ccc;
      }

      .tab-content {
        flex: 1;
        padding: 20px;
      }

      .tab-content > div {
        display: none;
      }

      .tab-content h2 {
        margin-bottom: 10px;
      }

      .tab-content table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 20px;
      }

      .tab-content th, .tab-content td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: left;
      }

      .tab-content th {
        background-color: #f2f2f2;
      }

    </style>
</head>
<body>

    <!-- nav bar with logo -->
    <nav>
      <div class="links">
        <div class="logo">
            <a href="index.jsp">
              <img src="TaskULogo.png" alt="TaskU Logo">
            </a>
            <br>
        </div>
        <div class="nav-links">
            <span class="separator">|</span>
            <a href="dashboard.jsp?userID=<%= userID %>">Dashboard</a>
            <span class="separator">|</span>
            <a href="calendar.jsp">Calendar</a>
            <span class="separator">|</span>
            <a href="studytips.jsp">Study Tips</a>
            <span class="separator">|</span>
        </div>
      </div>
      <div class="user-profile">
           <span class="user-name">
               <%
                   // Display user's full name
                   if (userID != null) {
                       String fullName = "";
                       try {
                           Connection con = Util.get_conn();
                           PreparedStatement statement = con.prepareStatement("SELECT Name FROM users WHERE UserId = ?");
                           statement.setInt(1, userID);
                           ResultSet rs = statement.executeQuery();
                           if (rs.next()) {
                               fullName = rs.getString("Name");
                           } else {
                               response.sendRedirect("login.jsp");
                           }
                       } catch (SQLException e) {
                           e.printStackTrace();
                       }
                       out.print(fullName);
                   } else {
                       response.sendRedirect("login.jsp");
                   }
               %>
           </span>
           <a href="settings.jsp">
             <img src="user-icon.png" class="user-icon"  style="width: 50px; height: 50px;">
           </a>
       </div>
    </nav>


<div class="main-container">
    <div class="tabs-container">
        <button onclick="showTab('courseTab')">Courses</butotn>
        <button onclick="showTab('categoryTab')">Categories</button>
        <button onclick="showTab('rewardsTab')">Rewards</button>
        <button onclick="showTab('activitiesTab')">Activity Log</button>
        <br>

        <button onclick="confirmLogout()">Logout</button>

    </div>

    <div class="tab-content">
      <div id="courseTab">
          <h2>Courses</h2>
          <ul>
              <% for (String course : courses) { %>
                  <li><%= course %></li>
              <% } %>
          </ul>
          <form id="courseForm" action="settings.jsp" method="post">
              <label for="course">Course:</label>
              <input type="text" id="course" name="course" required style="width: 200px;">
              <button type="submit">Add Course</button>
          </form>
      </div>
        <div id="categoryTab">
            <h2>Categories</h2>
            <ul>
                <% for (String category : categories) { %>
                    <li><%= category %></li>
                <% } %>
            </ul>
            <form id="categoryForm" action="settings.jsp" method="post">
                <label for="category">Category:</label>
                <input type="text" id="category" name="category" required style="width: 200px;">
                <button type="submit">Add Category</button>
            </form>
        </div>

        <div id="rewardsTab">
            <h2>Rewards</h2>
            <%
                if (userID != null) {
                    PreparedStatement preparedStatement;
                    Statement statement;
                    ResultSet rs;
                    try {
                        Connection con = Util.get_conn();
                        preparedStatement = con.prepareStatement("SELECT * FROM tasks WHERE UserID = ? AND Status='Completed'");
                        preparedStatement.setInt(1, userID);
                        rs = preparedStatement.executeQuery();
                        int numTasksCompleted = 0;
                        while (rs.next()) {
                            numTasksCompleted++;
                        }
                        if (numTasksCompleted <= 0) {
                            out.println("No tasks completed.");
                            out.println("Stop procrastinating and get back to work!");
                        } else {
                            out.println("You have completed " + numTasksCompleted + (numTasksCompleted == 1 ? " task." : " tasks."));
                        }

                        //Give user achievements once they've met the requirements
                        statement = con.createStatement();
                        rs = statement.executeQuery("SELECT * FROM rewards");
                        while (rs.next()) {
                            int rewardID = rs.getInt("RewardID");
                            int rewardNumTasks = rs.getInt("NumTasks");
                            if (numTasksCompleted >= rewardNumTasks) {
                                preparedStatement = con.prepareStatement("INSERT INTO userrewards VALUES(?, ?)");
                                preparedStatement.setInt(1, userID);
                                preparedStatement.setInt(2, rewardID);
                                try {
                                    preparedStatement.execute();
                                } catch (SQLException ignore) {}
                            }
                        }

                        out.println("<h3> Achievements earned: </h3>");
                        preparedStatement = con.prepareStatement("SELECT * FROM userrewards NATURAL JOIN rewards WHERE UserID = ?");
                        preparedStatement.setInt(1, userID);
                        rs = preparedStatement.executeQuery();
                        if (rs.isBeforeFirst()) {
                            while (rs.next()) {
                                String rewardName = rs.getString("RewardName");
                                String rewardDesc = rs.getString("RewardDesc");
                                int rewardPoints = rs.getInt("RewardPoints");
                                out.println("<b>" + rewardName + "</b>" + " - " + rewardDesc + " - " + rewardPoints + " points");
                                out.println("<br>");
                            }
                        } else {
                            out.println("None");
                        }

                        out.println("<h3> Achievements available: </h3>");
                        statement = con.createStatement();
                        rs = statement.executeQuery("SELECT * FROM userrewards RIGHT JOIN rewards ON userrewards.RewardID = rewards.RewardID");
                        if (rs.isBeforeFirst()) {
                            while (rs.next()) {
                                String rewardName = rs.getString("RewardName");
                                String rewardDesc = rs.getString("RewardDesc");
                                int rewardPoints = rs.getInt("RewardPoints");
                                int joinUserID = rs.getInt("UserID");
                                if (joinUserID == 0) {
                                    out.println("<b>" + rewardName + "</b>" + " - " + rewardDesc + " - " + rewardPoints + " points");
                                    out.println("<br>");
                                }
                            }
                        } else {
                            out.println("You've earned them all! Wow!");
                        }
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
        </div>
        <div id="activitiesTab">
            <h2>Activity Log</h2>
            <table>
                <tr>
                    <th>Action</th>
                    <th>Timestamp</th>
                </tr>
                <%

                    if (userID != null) {
                        PreparedStatement preparedStatement;
                        Statement statement;
                        ResultSet rs;
                        try {
                            Connection con = Util.get_conn();
                            preparedStatement = con.prepareStatement("SELECT Activity, ActivityDate FROM activities WHERE UserID = ?");
                            preparedStatement.setInt(1, userID);
                            rs = preparedStatement.executeQuery();
                            while (rs.next()) {
                                out.println("<tr>");
                                out.println("<td>" + rs.getString("Activity") + "</td>");
                                out.println("<td>" + rs.getString("ActivityDate") + "</td>");
                                out.println("</tr>");
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                        }
                    }
                %>
            </table>
        </div>
    </div>
</div>

<script>
    var currentTab = localStorage.getItem('selectedTab') || 'courseTab';

    function showTab(tabName) {
        document.getElementById(currentTab).style.display = "none";
        document.getElementById(tabName).style.display = "block";
        currentTab = tabName;
        localStorage.setItem('selectedTab', currentTab);
    }

    // Restore the selected tab on page load
    document.addEventListener('DOMContentLoaded', function() {
        showTab(currentTab);

        if (!localStorage.getItem('selectedTab')) {
            showTab('courseTab');
        }
    });

    function confirmLogout() {
        var logoutConfirmation = confirm("Are you sure you want to log out?");
        if (logoutConfirmation) {
            window.location.href = "logout.jsp";
        }
    }
</script>
</body>
</html>
