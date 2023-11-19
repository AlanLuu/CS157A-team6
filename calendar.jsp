<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat" %>
<%@ include file="util.jsp" %>
<html>
<head>
    <title>Task Calendar</title>
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
    </style>    
</head>
<body>
    <h1>Task Calendar</h1>

    <%-- Connect to the database --%>
    <% 
        // Create a map to store tasks by date
        Map<String, List<String>> tasksByDate = new HashMap<>();
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        try {
            conn = Util.get_conn();
            stmt = conn.createStatement();
            
            // Execute SQL query to fetch tasks (replace with your actual query)
            String query = "SELECT Title, DueDate FROM Tasks ORDER BY DueDate";
            rs = stmt.executeQuery(query);
            
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
                Calendar calendar = Calendar.getInstance();
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
                    out.print("<strong>" + i + "</strong><br>"); // Display day number
                    
                    // Check if tasks exist for this date
                    if (tasksByDate.containsKey(currentDate)) {
                        List<String> tasks = tasksByDate.get(currentDate);
                        for (String task : tasks) {
                            out.print(task + "<br>"); // Display tasks for the day
                        }
                    }
                    out.print("</td>");
                    
                    calendar.add(Calendar.DAY_OF_MONTH, 1); // Move to the next day
                }
                
                out.println("</tr>");
            %>
        </table>
    </div>    
</body>
</html>

