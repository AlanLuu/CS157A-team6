<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, java.util.Map" %>
<%@ include file="util.jsp" %>
<%
  String updateTaskStatus = request.getParameter("updateTaskStatus");
  String newStatus = request.getParameter("newStatus");

  if (updateTaskStatus != null && newStatus != null) {
      try (Connection con = Util.get_conn();
           PreparedStatement updateTaskStatement = con.prepareStatement("UPDATE tasks SET Status = ? WHERE TaskID = ?")) {

          updateTaskStatement.setString(1, newStatus);
          updateTaskStatement.setString(2, updateTaskStatus);
          updateTaskStatement.executeUpdate();

          // If the task is marked as completed, also update subtask statuses
          if (newStatus.equals("Completed")) {
              try (PreparedStatement updateSubtaskStatement = con.prepareStatement("UPDATE subtasks SET SubTaskStatus = 'Completed' WHERE TaskId = ?")) {
                  updateSubtaskStatement.setString(1, updateTaskStatus);
                  updateSubtaskStatement.executeUpdate();
              }
          }
      } catch (SQLException e) {
          out.println("update task status error: " + e);
      }
  }
%>
<%
    // Handles updating the subtask status
    String updateSubtaskStatusId = request.getParameter("updateSubtaskStatus");
    String newSubtaskStatus = request.getParameter("newStatus");
    if (updateSubtaskStatusId != null && newSubtaskStatus != null) {
        try (Connection con = Util.get_conn();
             PreparedStatement statement = con.prepareStatement("UPDATE subtasks SET SubTaskStatus = ? WHERE SubTaskID = ?")) {

            statement.setString(1, newSubtaskStatus);
            statement.setString(2, updateSubtaskStatusId);
            statement.executeUpdate();

            // If the subtask is marked as completed or in progress, update the parent task's status
            if (newSubtaskStatus.equals("Completed") || newSubtaskStatus.equals("In Progress")) {
                try (PreparedStatement updateParentTaskStatement = con.prepareStatement("UPDATE tasks SET Status = 'In Progress' WHERE TaskID = (SELECT TaskId FROM subtasks WHERE SubTaskID = ?)")) {
                    updateParentTaskStatement.setString(1, updateSubtaskStatusId);
                    updateParentTaskStatement.executeUpdate();
                }
            }

            out.println("Subtask status updated successfully!");
        } catch (SQLException e) {
            out.println("update subtask status error: " + e);
        }
    }
%>
<%
    // Check if the request is to fetch categories
    if ("true".equals(request.getParameter("fetchCategories"))) {
        try (Connection con = Util.get_conn();
             PreparedStatement statement = con.prepareStatement("SELECT categoryName FROM categories");
             ResultSet rs = statement.executeQuery()) {

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
        // Function to open subtask modal
        function openSubtaskModal(taskId) {
            var subtaskModal = document.getElementById("subtaskModal" + taskId);
            subtaskModal.style.display = "block";
        }

        // Function to close subtask modal
        function closeSubtaskModal(taskId) {
            var subtaskModal = document.getElementById("subtaskModal" + taskId);
            subtaskModal.style.display = "none";
        }

        function toggleSubTaskDetails(subtaskId) {
             var subtaskDetails = document.getElementById(subtaskId);
             if (subtaskDetails.style.display === "block") {
                 subtaskDetails.style.display = "none";
             } else {
                 subtaskDetails.style.display = "block";
             }
         }

         function deleteSubtask(subtaskId) {
             var confirmed = confirm("Are you sure you want to delete this subtask?");
             if (confirmed) {
                 // Use AJAX to send a request to delete the subtask
                 var xhr = new XMLHttpRequest();
                 xhr.open("POST", "dashboard.jsp?deleteSubtask=" + subtaskId, true);
                 xhr.onreadystatechange = function () {
                     if (xhr.readyState === 4 && xhr.status === 200) {
                         // Refresh the subtask list after successful deletion
                         location.reload();
                     }
                 };
                 xhr.send();
             }
         }

         function updateTaskStatus(taskId) {
             var statusDropdown = document.getElementById("taskStatus" + taskId);

             if (!statusDropdown) {
                 console.error("Status dropdown not found for task ID: " + taskId);
                 return;
             }

             var newStatus = statusDropdown.options[statusDropdown.selectedIndex].value;

             var confirmation = confirm("Are you sure you want to change the status to " + newStatus + "?");
             if (confirmation) {
                 // Use AJAX to send a request to update the task status in the database
                 var xhr = new XMLHttpRequest();
                 xhr.open("POST", "dashboard.jsp?updateTaskStatus=" + taskId + "&newStatus=" + newStatus, true);
                 xhr.onreadystatechange = function () {
                     if (xhr.readyState === 4 && xhr.status === 200) {
                         // Fetch the current status from the server
                         var statusUpdateXHR = new XMLHttpRequest();
                         statusUpdateXHR.open("GET", "dashboard.jsp?fetchTaskStatus=" + taskId, true);
                         statusUpdateXHR.onreadystatechange = function () {
                             if (statusUpdateXHR.readyState === 4 && statusUpdateXHR.status === 200) {
                                 // Update the dropdown value with the current status
                                 statusDropdown.value = statusUpdateXHR.responseText;
                                 // Refresh the task list after a successful update
                                 location.reload();
                             }
                         };
                         statusUpdateXHR.send();
                     }
                 };
                 xhr.send();
             }
         }

       // Function to update subtask status using AJAX
       function updateSubtaskStatus(subtaskId, dropdownId) {
           var statusDropdown = document.getElementById(dropdownId);

           if (!statusDropdown) {
               console.error("Status dropdown not found for subtask ID: " + subtaskId);
               return;
           }

           var newStatus = statusDropdown.options[statusDropdown.selectedIndex].value;

           var confirmation = confirm("Are you sure you want to change the status to " + newStatus + "?");
           if (confirmation) {
               var xhr = new XMLHttpRequest();
               xhr.open("POST", "dashboard.jsp?updateSubtaskStatus=" + subtaskId + "&newStatus=" + newStatus, true);
               xhr.onreadystatechange = function () {
                   if (xhr.readyState === 4 && xhr.status === 200) {
                       var statusUpdateXHR = new XMLHttpRequest();
                       statusUpdateXHR.open("GET", "dashboard.jsp?fetchSubTaskStatus=" + subtaskId, true);
                       statusUpdateXHR.onreadystatechange = function () {
                           if (statusUpdateXHR.readyState === 4 && statusUpdateXHR.status === 200) {
                               statusDropdown.value = statusUpdateXHR.responseText;
                               location.reload();
                           }
                       };
                       statusUpdateXHR.send();
                   }
               };
               xhr.send();
           }
       }


       function startPomodoroTimer(taskId, taskTitle, subtaskId, subtaskName) {
           // Check if subtaskId is provided, if yes, redirect with subtask details, otherwise, redirect with task details
           if (subtaskId) {
               window.location.href = "pomodoroTimer.jsp?subtaskId=" + subtaskId + "&subtaskName=" + encodeURIComponent(subtaskName) + "&isSubtask=true";
           } else {
               window.location.href = "pomodoroTimer.jsp?taskId=" + taskId + "&taskTitle=" + encodeURIComponent(taskTitle) + "&isSubtask=false";
           }
       }


      function capitalizeFirstLetter(str) {
                  return str.charAt(0).toUpperCase() + str.slice(1);
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
                    Integer userID = (Integer) session.getAttribute("userID");
                    if (userID == null) {
                        response.sendRedirect("logout.jsp");
                        return;
                    }
                    String fullName = "";
                    try {
                        Connection con = Util.get_conn();
                        PreparedStatement statement = con.prepareStatement("SELECT Name FROM users WHERE UserID = ?");
                        statement.setInt(1, userID);
                        ResultSet rs = statement.executeQuery();
                        if (!rs.next()) {
                            response.sendRedirect("logout.jsp");
                            return;
                        }
                        fullName = rs.getString("Name");
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    out.print(fullName);
                %>
            </span>
            <a href="settings.jsp">
                <img src="user-icon.png" class="user-icon"  style="width: 50px; height: 50px;">
            </a>
        </div>
    </nav>

 <!-- Create Task Form Popup/Modal -->
    <div class="create-task-button">
      <button onclick="openTaskModal()">Create Task</button>
    </div>
    <form action="calendar.jsp">
      <button type="submit">Open Calendar</button>
    </form>
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
            String status = request.getParameter("status");

            try {
                Connection con = Util.get_conn();

                PreparedStatement statement = con.prepareStatement("INSERT INTO tasks (UserID, Title, Description, DueDate, Priority, Category, Status) VALUES (?, ?, ?, ?, ?, ?, ?)");
                statement.setInt(1, userID);
                statement.setString(2, title);
                statement.setString(3, description);
                statement.setString(4, dueDate);
                statement.setString(5, priority);
                statement.setString(6, category);
                statement.setString(7, status);

                statement.executeUpdate();

                response.sendRedirect("dashboard.jsp");
            } catch (SQLException e) {
                out.println("insert error: " + e);
            }
        }
    }
    %>

    <div class="task-list">
        <h2>Your Tasks</h2>
        <%
            if (userID != null) {
                try {
                    Connection con = Util.get_conn();
                    PreparedStatement statement = con.prepareStatement("SELECT * FROM tasks WHERE UserID = ? AND Status != 'Completed'");
                    statement.setInt(1, userID);
                    ResultSet rs = statement.executeQuery();
                    while (rs.next()) {
                        String taskId = rs.getString("TaskID");
                        String taskTitle = rs.getString("Title");
                    %>
                        <div class="task">
                        <h3 onclick="toggleTaskDetails('<%= taskId %>')">
                              <script>document.write(capitalizeFirstLetter('<%= taskTitle %>'));</script>
                          </h3>
                            <div id="<%= taskId %>" class="task-details" style="display: none;">
                                <p><strong>Task Description:</strong> <%= rs.getString("Description") %></p>
                                <p><strong>Due Date: </strong> <%= rs.getString("DueDate") %></p>
                                <p><strong>Priority: </strong> <%= rs.getString("Priority") %></p>
                                <p><strong>Category: </strong> <%= rs.getString("Category") %></p>
                                <p><strong>Status: </strong><select id="<%= "taskStatus" + taskId %>" name="taskStatus" onchange="updateTaskStatus('<%= taskId %>', this)">
                                    <option value="Not Started" <%= rs.getString("Status").equals("Not Started") ? "selected" : "" %>>Not Started</option>
                                    <option value="In Progress" <%= rs.getString("Status").equals("In Progress") ? "selected" : "" %>>In Progress</option>
                                    <option value="Completed" <%= rs.getString("Status").equals("Completed") ? "selected" : "" %>>Completed</option>
                                </select>
                                <br>
                                <button onclick="deleteTask('<%= taskId %>')">Delete</button>
                                <button onclick="openSubtaskModal('<%= taskId %>')">Add Subtask</button>
                                <button onclick="startPomodoroTimer('<%= taskId %>', '<%= taskTitle %>')">Start Pomodoro Timer</button>


                                <!-- Subtask Modal -->
                                <div id="subtaskModal<%= taskId %>" class="modal" style="display: none;">
                                    <div class="modal-content">
                                        <span class="close" onclick="closeSubtaskModal('<%= taskId %>')">&times;</span>
                                        <h2>Create a New Subtask</h2>
                                        <form id="createSubtaskForm<%= taskId %>">
                                            <!-- Subtask Form Details -->
                                            <input type="text" name="subtaskName" placeholder="Subtask Name" required>
                                            <input type="text" name="subtaskDescription" placeholder="Subtask Description">
                                            <input type="date" name="subtaskDueDate" required>
                                            <select name="subtaskStatus">
                                                <option value="Not Started">Not Started</option>
                                                <option value="In Progress">In Progress</option>
                                                <option value="Completed">Completed</option>
                                            </select>
                                            <input type="hidden" name="userIdForSubtask" value="<%= userID %>">
                                            <input type="hidden" name="taskIdForSubtask" value="<%= taskId %>">
                                            <button type="submit">Create Subtask</button>
                                        </form>
                                    </div>
                                </div>

                                <!-- Subtask List -->
                                <div id="subtaskList<%= taskId %>" class="subtask-list">
                                    <%
                                        // Retrieve and display subtasks for the current task
                                        PreparedStatement subtaskStatement = con.prepareStatement("SELECT * FROM subtasks WHERE TaskId = ?");
                                        subtaskStatement.setString(1, taskId);
                                        ResultSet subtaskRs = subtaskStatement.executeQuery();
                                        while (subtaskRs.next()) {
                                            String subtaskId = subtaskRs.getString("SubTaskID");
                                            String subtaskName = subtaskRs.getString("SubTaskName");
                                    %>
                                        <div class="subtask">
                                            <h3 onclick="toggleSubTaskDetails('<%= subtaskId %>')">
                                                <script>document.write(capitalizeFirstLetter('<%= subtaskName %>'));</script>
                                            </h3>

                                            <div id="<%= subtaskId %>" class="subtask-details" style="display: none;">
                                                <p><strong>Description:</strong> <%= subtaskRs.getString("SubTaskDescription") %></p>
                                                <p><strong>Due Date:</strong> <%= subtaskRs.getString("SubTaskDueDate") %></p>
                                                <p><strong>Status:</strong>
                                                <select id="<%= "subtaskStatus" + subtaskId %>" name="subtaskStatus" onchange="updateSubtaskStatus('<%= subtaskId %>', this.id)">
                                                      <option value="Not Started" <%= subtaskRs.getString("SubTaskStatus").equals("Not Started") ? "selected" : "" %>>Not Started</option>
                                                      <option value="In Progress" <%= subtaskRs.getString("SubTaskStatus").equals("In Progress") ? "selected" : "" %>>In Progress</option>
                                                      <option value="Completed" <%= subtaskRs.getString("SubTaskStatus").equals("Completed") ? "selected" : "" %>>Completed</option>
                                                  </select>
                                              </p>
                                              <br>
                                                <button onclick="deleteSubtask('<%= subtaskId %>')">Delete Subtask</button>
                                                <button onclick="startPomodoroTimer('<%= subtaskId %>', '<%= subtaskName %>')">Start Pomodoro Timer</button>
                                            </div>
                                        </div>
                                    <%
                                        }
                                        subtaskRs.close();
                                    %>
                                </div>
                            </div>
                        </div>
                        <br>
                    <%
                    }
                    rs.close();
                } catch (SQLException e) {
                    out.println("fetch error: " + e);
                }
            }
        %>
    </div>

        <%

        if (request.getParameter("subtaskName") != null) {
            if (userID != null) {
          // Handle Subtask Creation
          String subtaskName = request.getParameter("subtaskName");
          String subtaskDescription = request.getParameter("subtaskDescription");
          String subtaskStatus = request.getParameter("subtaskStatus");
          String taskIdForSubtask = request.getParameter("taskIdForSubtask");
          String userIdForSubtask = request.getParameter("userIdForSubtask");
          String subtaskDueDate = request.getParameter("subtaskDueDate");

              try {
                  Connection con = Util.get_conn();
                  PreparedStatement statement = con.prepareStatement("INSERT INTO subtasks (UserId, TaskId, SubTaskName, SubTaskDescription, SubTaskStatus, SubTaskDueDate) VALUES (?, ?, ?, ?, ?, ?)");
                  statement.setString(1, userIdForSubtask);
                  statement.setString(2, taskIdForSubtask);
                  statement.setString(3, subtaskName);
                  statement.setString(4, subtaskDescription);
                  statement.setString(5, subtaskStatus);
                  statement.setString(6, subtaskDueDate);

                  statement.executeUpdate();
                  response.sendRedirect("dashboard.jsp");
              } catch (SQLException e) {
                  e.printStackTrace();
              }
          }
        }
          %>

          <%
                // Handles the Delete Subtask function
                String deleteSubtaskId = request.getParameter("deleteSubtask");
                if (deleteSubtaskId != null) {
                    try {
                        Connection con = Util.get_conn();

                        PreparedStatement statement = con.prepareStatement("DELETE FROM subtasks WHERE SubTaskID = ?");
                        statement.setString(1, deleteSubtaskId);
                        statement.executeUpdate();
                    } catch (SQLException e) {
                        out.println("delete subtask error: " + e);
                    }
                }
            %>


        <%
            // Handles the Delete Task function
            String deleteTaskId = request.getParameter("deleteTask");
            if (deleteTaskId != null) {
                try {
                    Connection con = Util.get_conn();

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
