<%@ page import="java.sql.*"%>
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
            <form action="login.jsp" method="POST">
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
                if ("a@a.com".equals(enteredEmail) && "pass".equals(enteredPassword)) {
                    out.println("<h2>Login success</h2>");
                } else {
                    out.println("<h2>Login fail</h2>");
                }
            }
        %>
    </main>

</body>
</html>
