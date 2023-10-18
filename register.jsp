<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register for TaskU</title>
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
        <h1>Register for TaskU</h1>
    </header>

    <main>
        <section class="register-form">
            <h2>Register</h2>
            <form>
                <input type="text" name="full_name" placeholder="Full Name" required>
                <input type="email" name="email" placeholder="Email" required>
                <input type="password" name="password" placeholder="Password" required>
                <button type="submit">Register</button>
            </form>
            <br>
            <p class="register-link">Already have an account? <a href="login.jsp">Login here</a></p>
        </section>

        <%
            String enteredName = request.getParameter("full_name");
            String enteredEmail = request.getParameter("email");
            String enteredPassword = request.getParameter("password");

            if (enteredName != null && enteredEmail != null && enteredPassword != null) {
                String dbName = "tasku";
                String dbUser = "root";
                String dbPassword = "root";

                try {
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
                    PreparedStatement statement = con.prepareStatement("INSERT INTO users(Name, Email, Password) VALUES(?, ?, ?)");
                    statement.setString(1, enteredName);
                    statement.setString(2, enteredEmail);
                    statement.setString(3, enteredPassword);
                    statement.execute();
                    response.sendRedirect("login.jsp");
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
