<%@ page import="java.sql.*, java.util.*" %>
<%@ include file="util.jsp" %>
<html>
<head>
    <title>Study Tips</title>
    <link rel="stylesheet" href="styles.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
        }


        .container {
            max-width: calc(100vw - 100px); /* Slightly smaller than the length of the window */
            margin: 20px auto;
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .study-tip {
            margin-bottom: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 15px;
        }

        h2 {
            color: #333;
        }

        p {
            line-height: 1.5em;
        }
    </style>
</head>
<body>

<nav>
    <div class="links">
        <div class="logo">
            <a href="index.jsp">
                <img src="TaskULogo.png" alt="TaskU Logo">
            </a>
            <br>
        </div>
        <div class="nav-links">
            <span class="separator">|</span>
            <a href="dashboard.jsp">Dashboard</a>
            <span class="separator">|</span>
            <a href="calendar.jsp">Calendar</a>
            <span class="separator">|</span>
            <a href="studytips.jsp">Study Tips</a>
            <span class="separator">|</span>
        </div>
    </div>
    <div class="user-profile">
        <!-- Places the user's name at the top right by using the user's ID -->
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
            <img src="user-icon.png" class="user-icon" style="width: 50px; height: 50px;">
        </a>
    </div>
</nav>

<div class="container">
    <h1>Study Tips</h1>

    <div class="study-tip">
        <h2>Pomodoro Technique</h2>
        <p>The Pomodoro Technique is a time management method developed by Francesco Cirillo in the late 1980s. The technique uses a timer to break down work into intervals, traditionally 25 minutes in length, separated by short breaks.</p>
        <p>Here's how it works:</p>
        <ol>
            <li>Choose a task you want to work on.</li>
            <li>Set a timer for 25 minutes (1 pomodoro).</li>
            <li>Work on the task until the timer rings.</li>
            <li>Take a short break (5 minutes).</li>
            <li>Repeat the process.</li>
        </ol>
        <p>After completing four pomodoros, take a longer break (15–30 minutes). This technique helps improve focus and productivity while preventing burnout.</p>
    </div>

    <div class="study-tip">
        <h2>Active Recall</h2>
        <p>Active recall is a learning technique that involves actively retrieving information from your memory rather than passively reviewing materials. This can be done through flashcards, summarizing key concepts, or teaching the material to someone else.</p>
        <p>By actively engaging with the information, you strengthen your memory and improve long-term retention.</p>
    </div>

    <div class="study-tip">
        <h2>Time Blocking</h2>
        <p>Time blocking is a time management method where you schedule specific blocks of time for different tasks or activities. It helps you focus on one task at a time and avoids multitasking, leading to increased productivity.</p>
        <p>Identify your priorities and allocate dedicated time slots to work on them. This method can be applied to both study sessions and daily activities.</p>
    </div>

    <!-- Add more study tips here -->

</div>

</body>
</html>
