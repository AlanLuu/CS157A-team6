root<%@ page import="java.sql.*"%>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page session="false" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login to TaskU</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <nav>
        <a href="home.jsp">
            <div class="logo">
                <img src="TaskULogo.png" alt="TaskU Logo">
            </div>
        </a>
        <div class="login-register">
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
        </div>
    </nav>
    <header>
        <h1>Login to TaskU</h1>
    </header>

    <main>
        <section class="login-form">
            <h2>Login</h2>
            <form>
                <input type="email" name="email" placeholder="Email" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit">Login</button>
            </form>
            <br>
            <p class="register-link">Don't have an account? <a class="register-link" href="register.jsp">Register here</a></p>
        </section>

        <%
            String enteredEmail = request.getParameter("email");
            String enteredPassword = request.getParameter("password");

            if (enteredEmail != null && enteredPassword != null) {
                String dbName = "tasku";
                String dbUser = "root";
                String dbPassword = "root";
                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
                    PreparedStatement statement = con.prepareStatement("SELECT Password, UserID FROM users WHERE Email = ?");
                    statement.setString(1, enteredEmail);
                    ResultSet rs = statement.executeQuery();
                    if (rs.next()) {
                        String dbUserPassword = rs.getString("Password");
                        if (dbUserPassword.equals(enteredPassword)) {
                            int dbUserID = rs.getInt("UserID");
                            response.sendRedirect("dashboard.jsp?userID=" + dbUserID);
                        } else {
                            out.println("<h2>Incorrect username or password. Please try again.</h2>");
                        }
                    } else {
                        out.println("<h2>Incorrect username or password. Please try again.</h2>");
                    }
                } catch (SQLException e) {
                    out.println("There was a problem with the SQL connection. <br>");
                    out.println("Please make sure you have the correct database name, username, and password, and that the schema and tables have been created. <br>");
                    out.println("SQLException: " + e.getMessage());
                }
            }
        %>
    </main>

</body>
</html>
