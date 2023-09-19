<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
    <head>
        <title>TaskU</title>
        <style>
            table, th, td {
                border: 1px solid black;
                width: 40%;
            }
        </style>
    </head>

    <body>
        <h1>Welcome to TaskU, a task manager app for college students!</h1>
        <p>Here you can create tasks and efficiently manage them.</p>
        <p>It's a great way to keep track of your homework and projects!</p>
        <table>
            <tr>
                <th>Course ID</th>
                <th>Task title</th>
                <th>Task description</th>
                <th>Due Date</th>
                <th>Priority Level</th>
                <th>Category</th>
                <th>Status</th>
                <th>Allocated time</th>
                <th>Task creation date and time</th>
            </tr>
            <tr>
                <td>CS 131</td>
                <td>Complete assignment</td>
                <td>Complete worksheet 1</td>
                <td>9/21/2023</td>
                <td>High</td>
                <td>Homework</td>
                <td>In progress</td>
                <td>60 minutes</td>
                <td>2023-09-19 15:33:36</td>
            </tr>
             <%
                String dbName = "tasku";
                String dbUser = "root";
                String dbPassword = "root";
                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);

                    Statement statement = con.createStatement();
                    ResultSet rs = statement.executeQuery("SELECT * FROM tasks");
                    while (rs.next()) {
                        out.println("<tr>");
                        out.println("<td>" + rs.getString("CourseId") + "</td>");
                        out.println("<td>" + rs.getString("Title") + "</td>");
                        out.println("<td>" + rs.getString("Description") + "</td>");
                        out.println("<td>" + rs.getString("DueDate") + "</td>");
                        out.println("<td>" + rs.getString("Priority") + "</td>");
                        out.println("<td>" + rs.getString("Category") + "</td>");
                        out.println("<td>" + rs.getString("Status") + "</td>");
                        out.println("<td>" + rs.getString("AllocatedTime") + " minutes </td>");
                        out.println("<td>" + rs.getString("CreationDate") + "</td>");
                        out.println("</tr>");
                    }
                    rs.close();
                    statement.close();
                    con.close();
                } catch (SQLException e) {
                    out.println("There was a problem with the SQL connection. <br>");
                    out.println("Please make sure you have the correct database name, username, and password, and that the schema and tables have been created. <br>");
                    out.println("SQLException: " + e.getMessage());
                }
            %>
        </table>
    </body>
</html>
