<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ include file="util.jsp" %>

<%
    Integer userID = (Integer) session.getAttribute("userID");
    if (userID == null) {
        response.sendRedirect("logout.jsp");
        return;
    }

    // Fetch categories from the database for the specific user
    List<String> categories = new ArrayList<>();
    try {
        Connection con = Util.get_conn();
        PreparedStatement statement = con.prepareStatement("SELECT * FROM categories WHERE UserID = ?");
        statement.setInt(1, userID);
        ResultSet rs = statement.executeQuery();
        while (rs.next()) {
            categories.add(rs.getString("CategoryName"));
        }
    } catch (SQLException e) {
        out.println("fetch categories error: " + e);
    }

    // Handle category form submission
    String newCategory = request.getParameter("category");
    if (newCategory != null && !newCategory.isEmpty()) {
        try {
            Connection con = Util.get_conn();
            PreparedStatement statement = con.prepareStatement("INSERT INTO categories (UserID, CategoryName) VALUES (?, ?)");
            statement.setInt(1, userID);
            statement.setString(2, newCategory);
            statement.executeUpdate();
            // Redirect to the same page to refresh categories
            response.sendRedirect("settings.jsp");
        } catch (SQLException e) {
            out.println("insert category error: " + e);
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TaskU Settings</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>

    <!-- nav bar with logo -->
    <nav>
   <div class="logo">
       <img src="TaskULogo.png" alt="TaskU Logo">
         <br>
       <div class="nav-links">
           <a href="dashboard.jsp?userID=<%= userID %>">| Dashboard |</a>
       </div>
   </div>
   <div class="user-profile">
       <!-- Places the user's name at the top right by using the user's ID -->
       <span class="user-name">
           <%
               // Display user's full name
               if (userID != null) {
                   String fullName = "";
                   try {
                       Connection con = Util.get_conn();
                       PreparedStatement statement = con.prepareStatement("SELECT Name FROM users WHERE UserId = ?");
                       statement.setInt(1, userID);
                       ResultSet rs = statement.executeQuery();
                       if (rs.next()) {
                           fullName = rs.getString("Name");
                       } else {
                           response.sendRedirect("login.jsp");
                       }
                   } catch (SQLException e) {
                       e.printStackTrace();
                   }
                   out.print(fullName);
               } else {
                   response.sendRedirect("login.jsp");
               }
           %>
       </span>
       <a href="settings.jsp">
           <img src="user-icon.png" class="user-icon">
       </a>
   </div>
</nav>
    <div class="tab-content">
        <div class="category-content">
            <h2>Categories</h2>
            <ul>
                <% for (String category : categories) { %>
                    <li><%= category %></li>
                <% } %>
            </ul>
            <!-- Add a form to allow users to add categories -->
            <form id="categoryForm" action="settings.jsp" method="post">
                <label for="category">Category:</label>
                <input type="text" id="category" name="category" required style="width: 200px;">
                <button type="submit">Add Category</button>
            </form>
        </div>
        <div class="customization-content">
            <!-- Add content for the customization tab -->
        </div>
        <!-- Add more content divs for additional tabs -->
    </div>
    <form action="logout.jsp">
      <button type="submit">Logout</button>
    </form>
</body>
</html>
