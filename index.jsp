<!DOCTYPE html>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to TaskU</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f4;
        }



        header {
            text-align: center;
            padding: 50px;
            background-color: #009688;
            color: white;
        }

        main {
            padding: 20px;
        }

        section {
            margin-bottom: 30px;
        }

        h2 {
            color: #009688;
            text-align: center;
        }

        .info p {
            font-size: 18px;
            line-height: 1.6;
            color: #666;
            text-align: center;
        }

        .features {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
        }

        .feature {
            text-align: center;
            margin: 15px;
            padding: 20px;
            background-color: white;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        .cta {
            text-align: center;
            padding: 50px;
            background-color: #333;
            color: white;
        }

        .cta a {
            display: inline-block;
            padding: 15px 30px;
            background-color: #009688;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            font-size: 18px;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <nav>
        <div class="logo">
            <img src="TaskULogo.png" alt="TaskU Logo">
        </div>
        <div class="login-register">
            <a href="login.jsp">Login</a>
            <a href="register.jsp">Register</a>
        </div>
    </nav>
    <header>
        <h1>Welcome to TaskU</h1>
        <p>Your personal task management app</p>
    </header>

    <main>
        <section class="info">
            <h2>About TaskU</h2>
            <p>TaskU is a web application that allows you to manage and track your daily tasks.</p>
            <p>It's a great way to keep track of your homework and projects!</p>
        </section>

        <section class="features">
            <div class="feature">
                <h2>Easy to Use</h2>
                <p>Intuitive interface for seamless task management.</p>
            </div>

            <div class="feature">
                <h2>Organize Tasks</h2>
                <p>Categorize your tasks for better organization and prioritization.</p>
            </div>

            <div class="feature">
                <h2>Calendar</h2>
                <p>View all of your tasks in a calendar view for better organizaiton.</p>
            </div>
        </section>
    </main>
</body>
</html>
