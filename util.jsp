<%@ page import="java.sql.*" %>
<%--<%@ page import="org.mindrot.jbcrypt.BCrypt" %>--%>

<%!
    public static class Util {
        public static Connection get_conn() throws SQLException {
            String dbName = "tasku";
            String dbUser = "root";
            String dbPassword = "root";
            return DriverManager.getConnection("jdbc:mysql://localhost:3306/" + dbName, dbUser, dbPassword);
        }

//        public static String hashPassword(String password) {
//            return BCrypt.hashpw(password, BCrypt.gensalt(12));
//        }
//
//        public static boolean checkHashedPassword(String password, String hash) {
//            return BCrypt.checkpw(password, hash);
//        }
    }
%>
