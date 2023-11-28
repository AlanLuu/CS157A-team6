<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="util.jsp" %>
<html>
<head>
    <title>Task Calendar</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        .calendar {
            font-family: Arial, sans-serif;
            border-collapse: collapse;
            margin-top: 20px;
        }
    
        .calendar th {
            background-color: #f2f2f2;
            text-align: center;
            padding: 8px;
        }
    
        .calendar td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: center;
        }
    
        .calendar td strong {
            display: block;
            margin-bottom: 5px;
        }

        .tasks {
            line-height: 1.5em;
        }
    </style>
    <script>
        function goToNextMonth() {
            // JavaScript function to navigate to the next month
            // You can use AJAX to fetch data for the next month and update the calendar content
            // Here, we're simply redirecting to the same page with a query parameter indicating the next month
            // Get the URL of the current page
            var url = window.location.href;

            // Create a URLSearchParams object by passing the URL
            var searchParams = new URLSearchParams(url);

            // Access the "year" and "month" query parameters
            var year = searchParams.get("year");
            var month = searchParams.get("month");

            var currentDate = new Date();
            var currentYear = currentDate.getFullYear();
            var currentMonth = currentDate.getMonth() + 2; // +2 to get the next month

            if (year === null) {
                year = currentYear;
            }
            if (month === null) {
                month = currentMonth;
            } else {
                month = Number(month)
                month += 1;
            }

            // If current month is December, go to next year
            if (month === 13) {
                year += 1;
                month = 1; // January of the next year
            }

            // Redirect to the same page with the next month as a query parameter
            window.location.href = "calendar.jsp?year=" + year + "&month=" + month;
        }

        function goToPreviousMonth() {
            // JavaScript function to navigate to the previous month
            // Similar to goToNextMonth(), but navigating to the previous month
            // Here, we're redirecting to the same page with a query parameter indicating the previous month
            // Get the URL of the current page
            var url = window.location.href;

            // Create a URLSearchParams object by passing the URL
            var searchParams = new URLSearchParams(url);

            // Access the "year" and "month" query parameters
            var year = searchParams.get("year");
            var month = searchParams.get("month");

            var currentDate = new Date();
            var currentYear = currentDate.getFullYear();
            var currentMonth = currentDate.getMonth(); // Current month

            if (year === null) {
                year = currentYear;
            }
            if (month === null) {
                month = currentMonth;
            } else {
                month -= 1;
            }

            // If current month is January, go to previous year
            if (month === 0) {
                year -= 1;
                month = 12; // December of the previous year
            }

            // Redirect to the same page with the previous month as a query parameter
            window.location.href = "calendar.jsp?year=" + year + "&month=" + month;
        }
    </script>
</head>
<body>

  <nav>

      <div class="logo">
          <img src="TaskULogo.png" alt="TaskU Logo">
          <br>
          <div class="nav-links">
              <a href="dashboard.jsp"> | Dashboard |</a>
          </div>
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
    <h1>Task Calendar</h1>

    <%-- Connect to the database --%>
    <%
        // Create a map to store tasks by date
        Map<String, List<String>> tasksByDate = new HashMap<>();
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            conn = Util.get_conn();
            stmt = conn.prepareStatement("SELECT Title, DueDate FROM Tasks WHERE UserID = ? AND Status != 'Completed' ORDER BY DueDate");
            stmt.setInt(1, userID);
            rs = stmt.executeQuery();

            // Process results and store tasks by date
            while (rs.next()) {
                String taskDate = rs.getString("DueDate");
                String taskName = rs.getString("Title");

                // Store tasks in the map
                if (tasksByDate.containsKey(taskDate)) {
                    tasksByDate.get(taskDate).add(taskName);
                } else {
                    List<String> tasks = new ArrayList<>();
                    tasks.add(taskName);
                    tasksByDate.put(taskDate, tasks);
                }
            }

            // Generate Calendar Grid
            // Display calendar days and populate tasks for each day
            // ... (code to generate calendar)

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            // Close resources
            try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (stmt != null) stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>

    <div class="calendar">
        <table>
            <tr>
                <th>Sun</th>
                <th>Mon</th>
                <th>Tue</th>
                <th>Wed</th>
                <th>Thu</th>
                <th>Fri</th>
                <th>Sat</th>
            </tr>
            <%
                int year, month;

                // Retrieve year and month from query parameters
                if (request.getParameter("year") != null && request.getParameter("month") != null) {
                    year = Integer.parseInt(request.getParameter("year"));
                    month = Integer.parseInt(request.getParameter("month"));
                } else {
                    // If no parameters, use the current year and month
                    Calendar currentDate = Calendar.getInstance();
                    year = currentDate.get(Calendar.YEAR);
                    month = currentDate.get(Calendar.MONTH) + 1; // Note: Calendar.MONTH is 0-based
                }

                Calendar calendar = Calendar.getInstance();
                calendar.set(Calendar.YEAR, year);
                calendar.set(Calendar.MONTH, month - 1); // Calendar.MONTH is 0-based
                calendar.set(Calendar.DAY_OF_MONTH, 1); // Set calendar to the first day of the month

                int startingDayOfWeek = calendar.get(Calendar.DAY_OF_WEEK); // Get the starting day of the week for the month

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                int daysInMonth = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);

                // Determine the number of placeholder cells needed before the actual days start
                int numOfEmptyCells = (startingDayOfWeek + 6) % 7; // Calculate the number of empty cells

                out.println("<tr>");
                for (int i = 0; i < numOfEmptyCells; i++) {
                    out.println("<td></td>"); // Empty cells before the start of the month
                }

                // Loop to create calendar grid for the entire month
                for (int i = 1; i <= daysInMonth; i++) {
                    if (calendar.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY && i != 1) {
                        out.println("</tr><tr>"); // Start a new row for Sundays
                    }

                    String currentDate = sdf.format(calendar.getTime());
                    out.print("<td>");
                    out.print("<strong>" + i + "</strong>"); // Display day number

                    // Check if tasks exist for this date
                    if (tasksByDate.containsKey(currentDate)) {
                        List<String> tasks = tasksByDate.get(currentDate);
                        for (String task : tasks) {
                            out.print("<span class='tasks'> - " + task + "</span><br>"); // Display tasks for the day
                        }
                    } else {
                        out.println("<br>");
                    }
                    out.print("</td>");

                    calendar.add(Calendar.DAY_OF_MONTH, 1); // Move to the next day
                }

                out.println("</tr>");
            %>
        </table>
        <!-- Buttons to navigate to previous and next months -->
        <button onclick="goToPreviousMonth()">Previous Month</button>
        <button onclick="goToNextMonth()">Next Month</button>
    </div>
</body>
</html>
