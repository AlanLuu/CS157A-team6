<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="util.jsp" %>

<%
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("logout.jsp");
        return;
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
        .tab-content {
            text-align: center;
        }
        .tab-content > div {
            margin-bottom: 30px;
        }
        table {
            border-collapse: collapse;
            width: 50%;
            margin: 20px auto;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

    <!-- nav bar with logo -->
    <nav>
   <div class="logo">
       <img src="TaskULogo.png" alt="TaskU Logo">
         <br>
       <div class="nav-links">
           <a href="dashboard.jsp?userID=<%= userID %>">| Dashboard |</a>
       </div>
   </div>
   <div class="user-profile">
       <!-- Places the user's name at the top right by using the user's ID -->
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
           <img src="user-icon.png" class="user-icon">
       </a>
   </div>
</nav>
    <div class="tab-content">
        <div class="category-content">
            <h2>Categories</h2>
            <ul>
                <% for (String category : categories) { %>
                    <li><%= category %></li>
                <% } %>
            </ul>
            <!-- Add a form to allow users to add categories -->
            <form id="categoryForm" action="settings.jsp" method="post">
                <label for="category">Category:</label>
                <input type="text" id="category" name="category" required style="width: 200px;">
                <button type="submit">Add Category</button>
            </form>
        </div>
        <div class="customization-content">
            <!-- Add content for the customization tab -->
        </div>
        <div class="rewards-content">
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
        <div class="activities-content">
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
        <!-- Add more content divs for additional tabs -->
    </div>
    <form action="logout.jsp">
      <button type="submit">Logout</button>
    </form>
</body>
</html>
