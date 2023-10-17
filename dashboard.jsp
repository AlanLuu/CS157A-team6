<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
    HttpSession session = request.getSession(false); // Get the session without creating a new one
    if (session != null) {
        String userId = (String) session.getAttribute("userId");
    } else {
        // Session not found, handle the case when the user is not logged in
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

      function createTask() {
        var form = document.getElementById('createTaskForm');
        var formData = new FormData(form);

        // Use AJAX to send the form data to createTask.jsp
        var xhr = new XMLHttpRequest();
        xhr.open("POST", "createTask.jsp", true);
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // Handle the response from createTask.jsp if needed
                // Close the modal if task creation was successful
                closeTaskModal();
                // You can also refresh or update the task list on dashboard.jsp
                // without redirecting.
            }
        };
        xhr.send(formData);
      }
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
          if (event.target == modal) {
              modal.style.display = "none";
          }
      }

       function openTaskForm() {
           var taskForm = document.getElementById("taskForm");
           taskForm.style.display = "block";
       }

       function closeTaskForm() {
           var taskForm = document.getElementById("taskForm");
           taskForm.style.display = "none";
       }

       function showTaskDetails(taskId) {
           var taskDetails = document.getElementById(taskId);
           taskDetails.style.display = "block";
       }

       function closeTaskDetails(taskId) {
           var taskDetails = document.getElementById(taskId);
           taskDetails.style.display = "none";
       }
   </script>
</head>
<body>
    <nav>

        <div class="logo">
            <img src="TaskULogo.png" alt="TaskU Logo">
        </div>

        <div class="nav-links">
            <a href="#">Study Tips</a>
            <a href="#">Calendar</a>
        </div>
        <div class="user-profile">
            <img src="user-icon.png" alt="User Icon" style="width: 50px; height: 50px;">
            <span>
                <%
                    if (userID != null) {
                        String fullName = "";
                        try {
                            String dbName = "tasku";
                            String dbUser = "root";
                            String dbPassword = "root";
                            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
                            PreparedStatement statement = con.prepareStatement("SELECT Name FROM users WHERE UserID = ?");
                            statement.setString(1, userID);
                            ResultSet rs = statement.executeQuery();
                            if (rs.next()) {
                                fullName = rs.getString("Name");
                            }
                        } catch (SQLException e) {
                            // Handle database connection error
                            e.printStackTrace();
                        }
                        out.print(fullName);
                    } else {
                        // Handle the case when the user is not logged in
                    }
                %>
            </span>
        </div>
    </nav>

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
              <input type="text" name="category" placeholder="Task Category">
              <input type="text" name="allocatedTime" placeholder="Allocated Time">
              <select name="status">
                  <option value="Not Started">Not Started</option>
                  <option value="In Progress">In Progress</option>
                  <option value="Completed">Completed</option>
              </select>
                <button type="submit">Create Task</button>
            </form>
        </div>
    </div>

    <div class="task-list">
            <h2>Your Tasks</h2>
            <%
                if (UserID != null) {
                    try {
                        String dbName = "tasku";
                        String dbUser = "root";
                        String dbPassword = "graser10";
                        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
                        PreparedStatement statement = con.prepareStatement("SELECT * FROM tasks WHERE UserID = ?");
                        statement.setString(1, UserID);
                        ResultSet rs = statement.executeQuery();
                        while (rs.next()) {
                            String taskId = rs.getString("TaskID");
                            String taskTitle = rs.getString("Title");
                            %>
                            <div class="task" onclick="showTaskDetails('<%= taskId %>')">
                                <h3><%= taskTitle %></h3>
                            </div>
                            <div id="<%= taskId %>" class="task-details">
                                <span class="close" onclick="closeTaskDetails('<%= taskId %>')">&times;</span>
                                <h2><%= taskTitle %></h2>
                                <p>Task Description: <%= rs.getString("Description") %></p>
                                <p>Due Date: <%= rs.getString("DueDate") %></p>
                                <p>Priority: <%= rs.getString("Priority") %></p>
                                <p>Category: <%= rs.getString("Category") %></p>
                                <p>Allocated Time: <%= rs.getString("AllocatedTime") %></p>
                                <p>Status: <%= rs.getString("Status") %></p>
                            </div>
                            <%
                        }
                    } catch (SQLException e) {
                        // Handle database connection error
                        e.printStackTrace();
                    }
                }
            %>
        </div>


</body>
</html>
