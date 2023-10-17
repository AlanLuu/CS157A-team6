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
<%
String userId = request.getParameter("UserID");
String title = request.getParameter("title");
String description = request.getParameter("description");
String dueDate = request.getParameter("dueDate");
String priority = request.getParameter("priority");
String category = request.getParameter("category");
String allocatedTime = request.getParameter("allocatedTime");
String status = request.getParameter("status");

if (userId != null && title != null && dueDate != null && priority != null && status != null) {
    try {
        String dbName = "tasku";
        String dbUser = "root";
        String dbPassword = "root";
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
        PreparedStatement statement = con.prepareStatement("INSERT INTO tasks (UserID, Title, Description, DueDate, Priority, Category, AllocatedTime, Status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        statement.setString(1, userId);
        statement.setString(2, title);
        statement.setString(3, description);
        statement.setString(4, dueDate);
        statement.setString(5, priority);
        statement.setString(6, category);
        statement.setString(7, allocatedTime);
        statement.setString(8, status);
        statement.executeUpdate();

        // Redirect the user back to the homepage
        response.sendRedirect("home.jsp");
    } catch (SQLException e) {
        // Handle database connection error
        e.printStackTrace();
    }
}
%>
