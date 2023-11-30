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
          body {
              display: flex;
              align-items: center;
              justify-content: center;
              height: 100vh;
              margin: 0;
              font-family: 'Arial', sans-serif;
              background-color: #f7f7f7;
          }

          .timer-container {
              text-align: center;
              background-color: #fff;
              padding: 20px;
              border-radius: 8px;
              box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
              margin-top: 50px;

          }

          h1 {
              color: #333;
          }

          h2 {
              margin-top: 10px;
              color: #555;
          }

          #timerDisplay {
              font-size: 64px;
              font-weight: bold;
              color: #e44d26;
              margin: 20px 0;
          }

          button {
              margin: 10px;
              padding: 10px 20px;
              font-size: 16px;
              border: none;
              border-radius: 5px;
              cursor: pointer;
          }

  

          label {
              margin-top: 10px;
              display: block;
              color: #555;
          }

          input {
              margin-bottom: 10px;
              padding: 8px;
              font-size: 14px;
          }


          .popup {
              display: none;
              position: fixed;
              top: 0;
              left: 0;
              width: 100%;
              height: 100%;
              background: rgba(0, 0, 0, 0.5);
              justify-content: center;
              align-items: center;
          }

          .popup-content {
              background: #fff;
              padding: 20px;
              border-radius: 8px;
              box-shadow: 0 0 10px rgba(0, 0, 0, 0.2);
          }
      </style>

    <script>
      var workDuration = 25 * 60; // 25 minutes for work
      var shortBreakDuration = 5 * 60; // 5 minutes for short break
      var longBreakDuration = 15 * 60; // 15 minutes for long break
      var pomodoroCount = 0;
      var remainingTime = workDuration;
      var timerInterval;

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
                  pomodoroCount++;
                  if (pomodoroCount % 4 === 0) {
                      alert("Great job! Take a long break.");
                      startBreak(longBreakDuration);
                  } else {
                      alert("Pomodoro session completed! Take a short break.");
                      startBreak(shortBreakDuration);
                  }
              } else {
                  remainingTime--;
                  updateTimerDisplay();
              }
          }, 1000);
      }

      function startBreak(duration) {
          clearInterval(timerInterval);
          remainingTime = duration;
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

      function updateDurations() {
          workDuration = parseInt(document.getElementById('workDuration').value) * 60;
          shortBreakDuration = parseInt(document.getElementById('shortBreakDuration').value) * 60;
          longBreakDuration = parseInt(document.getElementById('longBreakDuration').value) * 60;

          if (timerInterval) {
              remainingTime = workDuration;
              updateTimerDisplay();
          }

          togglePopup();
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

        function togglePopup() {
            var popup = document.getElementById("durationPopup");
            popup.style.display = popup.style.display === "none" ? "flex" : "none";
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
         <button onclick="pauseTimer()">Pause Timer</button>
         <button onclick="startBreak()">Start Break</button>
         <button onclick="resetTimer()">Reset</button>
         <br>
         <button onclick="doneWorking()">Done Working</button>
         <button class="update-btn" onclick="togglePopup()">Update Durations</button>
     </div>

     <div id="durationPopup" class="popup">
         <div class="popup-content">
             <h2>Edit Durations</h2>
             <label for="workDuration">Work Duration (minutes):</label>
             <input type="number" id="workDuration" value="25">

             <label for="shortBreakDuration">Short Break Duration (minutes):</label>
             <input type="number" id="shortBreakDuration" value="5">

             <label for="longBreakDuration">Long Break Duration (minutes):</label>
             <input type="number" id="longBreakDuration" value="15">
              <br>
             <button class="update-btn" onclick="updateDurations()">Update</button>
             <button onclick="togglePopup()">Cancel</button>
         </div>
     </div>
</body>
</html>
