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
                <input type="text" placeholder="Full Name" required>
                <input type="email" placeholder="Email" required>
                <input type="password" placeholder="Password" required>
                <button type="submit">Register</button>
            </form>
            <br>
            <p class="register-link">Already have an account? <a href="login.jsp">Login here</a></p>
        </section>
    </main>


</body>
</html>
