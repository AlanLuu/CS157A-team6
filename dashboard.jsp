<%@ page import="java.sql.*, java.util.ArrayList, java.util.List, java.util.Arrays, java.util.Map, java.time.*" %>
<%@ page import="java.text.DateFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="util.jsp" %>

<%
  String[] statusFilters = request.getParameterValues("statusFilter");
  String[] categoryFilters = request.getParameterValues("categoryFilter");
  String[] priorityFilters = request.getParameterValues("priorityFilter");
%>
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
    if ("true".equals(request.getParameter("fetchCategories"))) {
        Integer userID = (Integer) session.getAttribute("userID");

        if (userID != null) {
            try (Connection con = Util.get_conn();
                 PreparedStatement statement = con.prepareStatement("SELECT categoryName FROM categories WHERE UserID = ?");
            ) {
                statement.setInt(1, userID);

                try (ResultSet rs = statement.executeQuery()) {
                    List<String> categories = new ArrayList<>();
                    while (rs.next()) {
                        categories.add(rs.getString("categoryName"));
                    }

                    // Print categories as a comma-separated string
                    out.print(String.join(",", categories));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            out.print("User ID not found in the session.");
        }

        return;
    }
%>
<%
    String setReminderTaskId = request.getParameter("setReminderTaskId");
    if (setReminderTaskId != null) {
        try (Connection con = Util.get_conn()) {
            PreparedStatement checkReminderStatement = con.prepareStatement("SELECT * FROM reminders WHERE TaskID = ?");
            checkReminderStatement.setString(1, setReminderTaskId);
            ResultSet rs = checkReminderStatement.executeQuery();
            if (!rs.isBeforeFirst()) {
                PreparedStatement setReminderPStatement = con.prepareStatement("INSERT INTO reminders(TaskID) VALUES(?)");
                setReminderPStatement.setString(1, setReminderTaskId);
                setReminderPStatement.execute();
            } else {
                response.sendError(403);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <style>
        .dashboard-container {
            display: flex;
            align-items: flex-start; /* Align items to the top */
        }

        .filter-section {
            flex: 0 0 15%; /* Set the width of the filter section */
            padding: 20px;
            border-right: 1px solid #ccc;
        }

        .task-list {
            flex: 1; /* Let the task list fill the remaining space */
            background-color: #f0f0f0;
            padding: 20px;
            border: 2px solid #ccc;
            border-radius: 5px;
            margin: 20px;
        }

        input[type="checkbox"] {
            width: auto; /* Set width to auto for checkbox inputs */
            margin: 0; /* Reset margin for checkbox inputs */
        }
        .checkbox-wrapper {
          white-space: nowrap;
        }
        .checkbox {
          vertical-align: top;
          display:inline-block;
        }
        .checkbox-label {
          white-space: normal;
          display:inline-block;
        }

    </style>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskU Dashboard</title>
    <link rel="stylesheet" href="styles.css">
      <script>

      document.addEventListener("DOMContentLoaded", function() {
          var xhr = new XMLHttpRequest();
          xhr.open("GET", "dashboard.jsp?fetchCategories=true", true);
          xhr.onreadystatechange = function() {
              if (xhr.readyState === 4 && xhr.status === 200) {
                  var categories = xhr.responseText.split(",");
                  populateCategories(categories);
                  populateCategoryFilter(categories);
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

       async function setReminder(taskId) {
           const response = await fetch("dashboard.jsp?setReminderTaskId=" + taskId, {
               method: "POST"
           });
           if (response.ok) {
               alert("Reminder successfully set.");
               location.reload();
           } else if (response.status === 403) {
               alert("Reminder is already set!");
           }
       }

      function capitalizeFirstLetter(str) {
            return str.charAt(0).toUpperCase() + str.slice(1);
      }

      function populateCategoryFilter(categories) {
          var categoryFilterContainer = document.getElementById("categoryFilterContainer");
              categories.forEach(function (category) {
              var checkbox = document.createElement("input");
              checkbox.type = "checkbox";
              checkbox.name = "categoryFilter";
              checkbox.value = category;

              var label = document.createElement("label");
              label.appendChild(checkbox);
              label.appendChild(document.createTextNode(" " + category));

              categoryFilterContainer.appendChild(label);
              categoryFilterContainer.appendChild(document.createElement("br"));
        });
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
                <input type="date" name="dueDate" required min="<%= java.time.LocalDate.now() %>">
                <select name="priority">
                    <option value="Low">Low</option>
                    <option value="Medium">Medium</option>
                    <option value="High">High</option>
                </select>
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

    <form method="post" action="<%= request.getRequestURI() %>">
        <input type="hidden" name="statusFilters" value="<%= Arrays.toString(statusFilters) %>">
        <input type="hidden" name="categoryFilters" value="<%= Arrays.toString(categoryFilters) %>">
        <input type="hidden" name="priorityFilters" value="<%= Arrays.toString(priorityFilters) %>">

        <div class="sort-section">
            <label for="sort">Sort by:</label>
            <select id="sort" name="sort">
                <option value="taskNameAsc">Task Name A->Z</option>
                <option value="taskNameDesc">Task Name Z->A</option>
                <option value="priorityLowToHigh">Priority Low to High</option>
                <option value="dueDateAsc">Due Date Nearest to Farthest</option>
            </select>
            <button type="submit">Apply Sort</button>
        </div>
    </form>


    <div class="dashboard-container">
        <!-- Filter Section -->
        <form method="post" action="<%= request.getRequestURI() %>">
          <div class="filter-section">
              <h2>Filter Tasks</h2>

              <!-- Status Filter -->
              <div class="filter-group">
                  <h3>Status</h3>
                  <div class="checkbox-wrapper">
                      <input id="status1" class="checkbox" type="checkbox" name="statusFilter" value="Not Started"/>
                      <label for="status1" class="checkbox-label">Not Started</label>
                  </div>
                  <div class="checkbox-wrapper">
                      <input id="status2" class="checkbox" type="checkbox" name="statusFilter" value="In Progress"/>
                      <label for="status2" class="checkbox-label">In Progress</label>
                  </div>
                  <div class="checkbox-wrapper">
                      <input id="status3" class="checkbox" type="checkbox" name="statusFilter" value="Completed"/>
                      <label for="status3" class="checkbox-label">Completed</label>
                  </div>
              </div>

              <!-- Category Filter -->
              <div class="filter-group">
                  <h3>Category</h3>
                  <div id="categoryFilterContainer">
                  </div>
              </div>

              <!-- Priority Filter -->
              <div class="filter-group">
                  <h3>Priority</h3>
                  <div class="checkbox-wrapper">
                      <input id="priority1" class="checkbox" type="checkbox" name="priorityFilter" value="Low"/>
                      <label for="priority1" class="checkbox-label">Low</label>
                  </div>
                  <div class="checkbox-wrapper">
                      <input id="priority2" class="checkbox" type="checkbox" name="priorityFilter" value="Medium"/>
                      <label for="priority2" class="checkbox-label">Medium</label>
                  </div>
                  <div class="checkbox-wrapper">
                      <input id="priority3" class="checkbox" type="checkbox" name="priorityFilter" value="High"/>
                      <label for="priority3" class="checkbox-label">High</label>
                  </div>
              </div>
                <button type="submit">Apply Filters</button>
          </div>
        </form>


      <div class="task-list">
          <h2>Your Tasks</h2>
          <%

          if (userID != null) {
              try {
                  Connection con = Util.get_conn();

                  String sortOption = request.getParameter("sort");

                  // Start building the SQL query for filters
                  StringBuilder filterQueryBuilder = new StringBuilder("SELECT * FROM tasks WHERE UserID = ? AND Status != 'Completed'");

                  // Add status filters to the query
                  if (statusFilters != null && statusFilters.length > 0) {
                      filterQueryBuilder.append(" AND Status IN (");
                      for (int i = 0; i < statusFilters.length; i++) {
                          filterQueryBuilder.append("?");
                          if (i < statusFilters.length - 1) {
                              filterQueryBuilder.append(", ");
                          }
                      }
                      filterQueryBuilder.append(")");
                  }

                  if (categoryFilters != null && categoryFilters.length > 0) {
                      filterQueryBuilder.append(" AND Category IN (");
                      for (int i = 0; i < categoryFilters.length; i++) {
                          filterQueryBuilder.append("?");
                          if (i < categoryFilters.length - 1) {
                              filterQueryBuilder.append(", ");
                          }
                      }
                      filterQueryBuilder.append(")");
                  }

                  if (priorityFilters != null && priorityFilters.length > 0) {
                      filterQueryBuilder.append(" AND Priority IN (");
                      for (int i = 0; i < priorityFilters.length; i++) {
                          filterQueryBuilder.append("?");
                          if (i < priorityFilters.length - 1) {
                              filterQueryBuilder.append(", ");
                          }
                      }
                      filterQueryBuilder.append(")");
                  }

                  // Continue with existing code for executing the filter query
                  PreparedStatement filterStatement = con.prepareStatement(filterQueryBuilder.toString());

                  // Set parameters for filters
                  int filterParamIndex = 1;

                  filterStatement.setInt(filterParamIndex++, userID); // Adding user ID

                  if (statusFilters != null) {
                      for (String status : statusFilters) {
                          filterStatement.setString(filterParamIndex++, status);
                      }
                  }

                  if (categoryFilters != null) {
                      for (String category : categoryFilters) {
                          filterStatement.setString(filterParamIndex++, category);
                      }
                  }

                  if (priorityFilters != null) {
                      for (String priority : priorityFilters) {
                          filterStatement.setString(filterParamIndex++, priority);
                      }
                  }

                  ResultSet rs = filterStatement.executeQuery();

                  // Create a new query to sort the filtered results
                  StringBuilder sortQueryBuilder = new StringBuilder(filterQueryBuilder.toString());

                  if ("taskNameAsc".equals(sortOption)) {
                      sortQueryBuilder.append(" ORDER BY CAST(Title AS SIGNED) ASC, Title ASC");
                  } else if ("taskNameDesc".equals(sortOption)) {
                      sortQueryBuilder.append(" ORDER BY CAST(Title AS SIGNED) ASC, Title DESC");
                  } else if ("priorityLowToHigh".equals(sortOption)) {
                      sortQueryBuilder.append(" ORDER BY CASE Priority WHEN 'Low' THEN 1 WHEN 'Medium' THEN 2 WHEN 'High' THEN 3 END ASC");
                  } else if ("dueDateAsc".equals(sortOption)) {
                      sortQueryBuilder.append(" ORDER BY STR_TO_DATE(DueDate, '%Y-%m-%d') ASC");
                  }

                  // Continue with existing code for executing the final query
                  PreparedStatement finalStatement = con.prepareStatement(sortQueryBuilder.toString());

                  // Set parameters for filters in the final query
                  int finalParamIndex = 1;

                  finalStatement.setInt(finalParamIndex++, userID); // Adding user ID

                  if (statusFilters != null) {
                      for (String status : statusFilters) {
                          finalStatement.setString(finalParamIndex++, status);
                      }
                  }

                  if (categoryFilters != null) {
                      for (String category : categoryFilters) {
                          finalStatement.setString(finalParamIndex++, category);
                      }
                  }

                  if (priorityFilters != null) {
                      for (String priority : priorityFilters) {
                          finalStatement.setString(finalParamIndex++, priority);
                      }
                  }

                  rs = finalStatement.executeQuery();

                  // Continue with existing code for displaying tasks
                  while (rs.next()) {
                          String taskId = rs.getString("TaskID");
                          String taskTitle = rs.getString("Title");
                          PreparedStatement reminderStatement = con.prepareStatement("SELECT * FROM reminders WHERE TaskID = ?");
                          reminderStatement.setString(1, taskId);
                          ResultSet reminderStatementSet = reminderStatement.executeQuery();
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
                                  <%
                                      if (reminderStatementSet.isBeforeFirst()) {
                                          reminderStatementSet.next();
                                          Timestamp reminderTs = reminderStatementSet.getTimestamp("SetTime");
                                          Date reminderDate = new Date(reminderTs.getTime());
                                          DateFormat df = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");
                                          out.println("<p>Reminder set on " + df.format(reminderDate) + "</p>");
                                      }
                                  %>
                                  <br>
                                  <button onclick="deleteTask('<%= taskId %>')">Delete</button>
                                  <button onclick="openSubtaskModal('<%= taskId %>')">Add Subtask</button>
                                  <button onclick="startPomodoroTimer('<%= taskId %>', '<%= taskTitle %>')">Start Pomodoro Timer</button>
                                  <button onclick="setReminder('<%= taskId %>')">Set reminder</button>


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
