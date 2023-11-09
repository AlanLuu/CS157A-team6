<%@ page import="java.sql.*, java.util.ArrayList, java.util.List" %>
<%
    // Check if the request is to fetch categories
    if ("true".equals(request.getParameter("fetchCategories"))) {
        try {
            String dbName = "tasku";
            String dbUser = "root";
            String dbPassword = "root";
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);

            PreparedStatement statement = con.prepareStatement("SELECT categoryName FROM categories");
            ResultSet rs = statement.executeQuery();

            List<String> categories = new ArrayList<>();
            while (rs.next()) {
                categories.add(rs.getString("categoryName"));
            }

            // Print categories as a comma-separated string
            out.print(String.join(",", categories));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskU Dashboard</title>
    <link rel="stylesheet" href="styles.css">
      <script>

      document.addEventListener("DOMContentLoaded", function() {
       // Fetch categories from the server
       var xhr = new XMLHttpRequest();
       xhr.open("GET", "dashboard.jsp?fetchCategories=true", true);
       xhr.onreadystatechange = function() {
         if (xhr.readyState === 4 && xhr.status === 200) {
           var categories = xhr.responseText.split(",");
           populateCategories(categories);
         }
       };
       xhr.send();
     });

     // Function to populate the category dropdown
     function populateCategories(categories) {
       var categoryDropdown = document.querySelector("select[name='category']");
       // Clear existing options
       categoryDropdown.innerHTML = "<option value='' disabled selected>Select Category</option>";
       // Add new options
       categories.forEach(function(category) {
         var option = document.createElement("option");
         option.value = category;
         option.textContent = category;
         categoryDropdown.appendChild(option);
       });
     }
      // Opens the popup/modal for the create task form.
      function openTaskModal() {
          var modal = document.getElementById("taskModal");
          modal.style.display = "block";
      }

      function closeTaskModal() {
          var modal = document.getElementById("taskModal");
          modal.style.display = "none";
      }

      // Close the modal when clicking outside the form
      window.onclick = function(event) {
          var modal = document.getElementById("taskModal");
          if (event.target === modal) {
              modal.style.display = "none";
          }
      }

      // Shows/Hides the details of the task upon clicking
       function toggleTaskDetails(taskId) {
            var taskDetails = document.getElementById(taskId);
            if (taskDetails.style.display === "block") {
                taskDetails.style.display = "none";
            } else {
                taskDetails.style.display = "block";
            }
        }

        //Delete Task confirmation
       function deleteTask(taskId) {
          var confirmed = confirm("Are you sure you want to delete this task?");
          if (confirmed) {
              // Use AJAX to send a request to delete the task
              var xhr = new XMLHttpRequest();
              xhr.open("POST", "dashboard.jsp?deleteTask=" + taskId, true);
              xhr.onreadystatechange = function () {
                  if (xhr.readyState === 4 && xhr.status === 200) {
                      // Refresh the task list after successful deletion
                      location.reload();
                  }
              };
              xhr.send();
          }
      }
   </script>
</head>
<body>

    <!-- nav bar with logo -->
    <nav>

        <div class="logo">
            <img src="TaskULogo.png" alt="TaskU Logo">
        </div>
        <div class="user-profile">
          <!--Places the user's name at the top right by using the user's ID -->
            <span class="user-name">
                <%
                    String userID = request.getParameter("userID");
                    if (userID != null) {
                        int userIDint = Integer.parseInt(userID);
                        String fullName = "";
                        try {
                            String dbName = "tasku";
                            String dbUser = "root";
                            String dbPassword = "root";
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
                            PreparedStatement statement = con.prepareStatement("SELECT Name FROM users WHERE UserID = ?");
                            statement.setInt(1, userIDint);
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
            <a href="settings.jsp?userID=<%= userID %>">
                <img src="user-icon.png" class="user-icon"  style="width: 50px; height: 50px;">
            </a>
        </div>
    </nav>

 <!-- Create Task Form Popup/Modal -->
    <div class="create-task-button">
      <button onclick="openTaskModal()">Create Task</button>
    </div>
    <div id="taskModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeTaskModal()">&times;</span>
            <h2>Create a New Task</h2>
            <form id="createTaskForm">
              <input type="text" name="title" placeholder="Task Title" required>
              <input type="text" name="description" placeholder="Task Description">
              <input type="date" name="dueDate" required>
                <select name="priority">
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                </select>
                <br>
                <select name="category">
                  <option value="" disabled selected>Select Category</option>
                </select>
              <input type="number" name="allocatedTime" placeholder="Allocated Time (Minutes)" required>
              <select name="status">
                  <option value="Not Started">Not Started</option>
                  <option value="In Progress">In Progress</option>
                  <option value="Completed">Completed</option>
              </select>
              <input type="hidden" name="userID" value="<%= userID %>">
                <button type="submit">Create Task</button>
            </form>
        </div>
    </div>

    <%
    // Handles creating the task and saving it to the database
    if (request.getParameter("title") != null) {

        if (userID != null) {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String dueDate = request.getParameter("dueDate");
            String priority = request.getParameter("priority");
            String category = request.getParameter("category");
            String allocatedTime = request.getParameter("allocatedTime");
            String status = request.getParameter("status");

            try {
                String dbName = "tasku";
                String dbUser = "root";
                String dbPassword = "root";
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);

                PreparedStatement statement = con.prepareStatement("INSERT INTO tasks (UserID, Title, Description, DueDate, Priority, Category, AllocatedTime, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                statement.setString(1, userID);
                statement.setString(2, title);
                statement.setString(3, description);
                statement.setString(4, dueDate);
                statement.setString(5, priority);
                statement.setString(6, category);
                statement.setString(7, allocatedTime);
                statement.setString(8, status);

                statement.executeUpdate();

                response.sendRedirect("dashboard.jsp?userID=" + userID);
            } catch (SQLException e) {
                out.println("insert error: " + e);
            }
        }
    }
    %>

    <!-- This container shows all of the user's tasks in list form from the database -->
    <div class="task-list">
            <h2>Your Tasks</h2>
            <%
                if (userID != null) {
                    try {
                        String dbName = "tasku";
                        String dbUser = "root";
                        String dbPassword = "root";
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
                        PreparedStatement statement = con.prepareStatement("SELECT * FROM tasks WHERE UserID = ?");
                        statement.setString(1, userID);
                        ResultSet rs = statement.executeQuery();
                        while (rs.next()) {
                            String taskId = rs.getString("TaskID");
                            String taskTitle = rs.getString("Title");
                            %>
                            <div class="task" onclick="toggleTaskDetails('<%= taskId %>')">
                                <h3><%= taskTitle %></h3>
                            </div>
                            <div id="<%= taskId %>" class="task-details">
                                <p>Task Description: <%= rs.getString("Description") %></p>
                                <p>Due Date: <%= rs.getString("DueDate") %></p>
                                <p>Priority: <%= rs.getString("Priority") %></p>
                                <p>Category: <%= rs.getString("Category") %></p>
                                <p>Allocated Time: <%= rs.getString("AllocatedTime") %></p>
                                <p>Status: <%= rs.getString("Status") %></p>
                                <br>
                                <button onclick="deleteTask('<%= taskId %>')">Delete</button>

                            </div>
                            <br>
                            <%
                        }
                    } catch (SQLException e) {
                        out.println("fetch error: " + e);
                    }
                }
            %>
        </div>


        <%
            // Handles the Delete Task function
            String deleteTaskId = request.getParameter("deleteTask");
            if (deleteTaskId != null) {
                try {
                    String dbName = "tasku";
                    String dbUser = "root";
                    String dbPassword = "root";
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);

                    PreparedStatement statement = con.prepareStatement("DELETE FROM tasks WHERE TaskID = ?");
                    statement.setString(1, deleteTaskId);
                    statement.executeUpdate();
                } catch (SQLException e) {
                    out.println("delete error: " + e);
                }
            }
        %>



</body>
</html>
