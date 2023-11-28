<%@ page import="java.sql.*, java.util.*, java.text.SimpleDateFormat, java.net.URLDecoder, java.io.UnsupportedEncodingException"%>
<%@ include file="util.jsp" %>
<%
    String taskId = request.getParameter("taskId");
    String taskTitle = request.getParameter("taskTitle");
    String subtaskId = request.getParameter("subtaskId");
    String subtaskName = request.getParameter("subtaskName");
    String isSubtaskParam = request.getParameter("isSubtask");

    boolean isSubtask = "true".equals(isSubtaskParam);


%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Pomodoro Timer</title>
    <style>
        /* Add your styles here */
        .timer-container {
            text-align: center;
            margin-top: 50px;
        }

        #timerDisplay {
            font-size: 24px;
        }

        button {
            margin: 10px;
            padding: 8px 16px;
            font-size: 16px;
        }
    </style>

    <script>
        var workDuration = 25 * 60; // 25 minutes for work
        var breakDuration = 5 * 60; // 5 minutes for break
        var remainingTime = workDuration;
        var timerInterval;
        var isSubtask = <%= request.getParameter("isSubtask") %>;
        function updateTimerDisplay() {
            var minutes = Math.floor(remainingTime / 60);
            var seconds = remainingTime % 60;
            document.getElementById('timerDisplay').innerText =
                (minutes < 10 ? '0' : '') + minutes + ':' + (seconds < 10 ? '0' : '') + seconds;
        }

        function startPomodoro() {
            clearInterval(timerInterval);
            remainingTime = workDuration;
            updateTimerDisplay();
            timerInterval = setInterval(function () {
                if (remainingTime <= 0) {
                    clearInterval(timerInterval);
                    alert("Pomodoro session completed! Take a break.");
                    startBreak();
                } else {
                    remainingTime--;
                    updateTimerDisplay();
                }
            }, 1000);
        }

        function startBreak() {
            clearInterval(timerInterval);
            remainingTime = breakDuration;
            updateTimerDisplay();
            timerInterval = setInterval(function () {
                if (remainingTime <= 0) {
                    clearInterval(timerInterval);
                    alert("Break time is over. Start another Pomodoro.");
                    startPomodoro();
                } else {
                    remainingTime--;
                    updateTimerDisplay();
                }
            }, 1000);
        }

        function resetTimer() {
            clearInterval(timerInterval);
            remainingTime = workDuration;
            updateTimerDisplay();
        }

        function pauseTimer() {
            // Pause the timer by clearing the interval
            clearInterval(timerInterval);
        }

        function doneWorking() {
            // Redirect the user back to the dashboard with the userID as a query parameter
            var userID = "<%= session.getAttribute("userID") %>";
            window.location.href = "dashboard.jsp?userID=" + userID;
        }

        function capitalizeFirstLetter(str) {
            return str.charAt(0).toUpperCase() + str.slice(1);
        }
    </script>
</head>
<body>
    <div id="pomodoroTimer" class="timer-container">
        <h1>Pomodoro Timer</h1>
        <div>
          <h2><script>document.write(capitalizeFirstLetter(isSubtask ? '<%= subtaskName %>' : '<%= taskTitle %>'));</script></h2>
        </div>
        <p id="timerDisplay">25:00</p>
        <button onclick="startPomodoro()">Start Pomodoro</button>
        <button onclick="pauseTimer()">Stop Timer</button>
        <button onclick="startBreak()">Start Break</button>
        <button onclick="resetTimer()">Reset</button>
        <br>
        <button onclick="doneWorking()">Done Working</button>
    </div>
</body>
</html>
