<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>
<%
    // Check if user is logged in
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String url = "jdbc:mysql://127.0.0.1:3308/roommatefinder";
    String dbUser = "root";
    String dbPass = "";

    Connection conn = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, dbUser, dbPass);

        // Get logged-in user's ID
        pst = conn.prepareStatement("SELECT id FROM users WHERE username=?");
        pst.setString(1, username);
        rs = pst.executeQuery();
        int userId = 0;
        if (rs.next()) {
            userId = rs.getInt("id");
        } else {
            throw new Exception("Logged-in user not found in database.");
        }
        rs.close();
        pst.close();

        // Insert current user's survey with user_id
        String insertSQL = "INSERT INTO student_survey(" +
                "user_id, name, gender, age, major, year, study_time, study_environment, learning_style," +
                "study_group, note_taking, exam_preparation, morning_or_night, quiet_or_noise, tidiness," +
                "study_hours, stress_management, intro_extro, group_or_oneonone, clubs, socialize_frequency," +
                "communication_style, hobbies, favorite_movies, activity_type, food_preference, academic_goal," +
                "career_goal, personal_goal, motivation" +
                ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

        pst = conn.prepareStatement(insertSQL);
        pst.setInt(1, userId); // set user_id first
        pst.setString(2, request.getParameter("name"));
        pst.setString(3, request.getParameter("gender"));
        pst.setInt(4, Integer.parseInt(request.getParameter("age")));
        pst.setString(5, request.getParameter("major"));
        pst.setString(6, request.getParameter("year"));
        pst.setString(7, request.getParameter("study_time"));
        pst.setString(8, request.getParameter("study_environment"));
        pst.setString(9, request.getParameter("learning_style"));
        pst.setString(10, request.getParameter("study_group"));
        pst.setString(11, request.getParameter("note_taking"));
        pst.setString(12, request.getParameter("exam_preparation"));
        pst.setString(13, request.getParameter("morning_or_night"));
        pst.setString(14, request.getParameter("quiet_or_noise"));
        pst.setString(15, request.getParameter("tidiness"));
        pst.setString(16, request.getParameter("study_hours"));
        pst.setString(17, request.getParameter("stress_management"));
        pst.setString(18, request.getParameter("intro_extro"));
        pst.setString(19, request.getParameter("group_or_oneonone"));
        pst.setString(20, request.getParameter("clubs"));
        pst.setString(21, request.getParameter("socialize_frequency"));
        pst.setString(22, request.getParameter("communication_style"));
        pst.setString(23, request.getParameter("hobbies"));
        pst.setString(24, request.getParameter("favorite_movies"));
        pst.setString(25, request.getParameter("activity_type"));
        pst.setString(26, request.getParameter("food_preference"));
        pst.setString(27, request.getParameter("academic_goal"));
        pst.setString(28, request.getParameter("career_goal"));
        pst.setString(29, request.getParameter("personal_goal"));
        pst.setString(30, request.getParameter("motivation"));
        pst.executeUpdate();
        pst.close();

        // Get current survey ID (optional)
        Statement stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT LAST_INSERT_ID() AS lastId");
        int currentSurveyId = 0;
        if (rs.next()) {
            currentSurveyId = rs.getInt("lastId");
        }
        rs.close();
        stmt.close();

        // Now you can safely fetch other surveys and calculate matches
        stmt = conn.createStatement();
        rs = stmt.executeQuery("SELECT * FROM student_survey WHERE user_id != " + userId);
        List<Map<String,String>> others = new ArrayList<>();
        while(rs.next()) {
            Map<String,String> map = new HashMap<>();
            ResultSetMetaData md = rs.getMetaData();
            for(int i=1; i<=md.getColumnCount(); i++) {
                map.put(md.getColumnName(i), rs.getString(i));
            }
            others.add(map);
        }
        rs.close();
        stmt.close();

        // Get current user's survey
        pst = conn.prepareStatement("SELECT * FROM student_survey WHERE user_id=?");
        pst.setInt(1, userId);
        rs = pst.executeQuery();
        Map<String,String> current = new HashMap<>();
        if(rs.next()) {
            ResultSetMetaData md = rs.getMetaData();
            for(int i=1; i<=md.getColumnCount(); i++) {
                current.put(md.getColumnName(i), rs.getString(i));
            }
        }
        rs.close();
        pst.close();

        // Calculate match scores
        Map<Map<String,String>,Integer> scores = new HashMap<>();
        String[] fields = {"gender","study_time","study_environment","learning_style","study_group",
                "note_taking","exam_preparation","morning_or_night","quiet_or_noise","intro_extro",
                "group_or_oneonone","clubs","socialize_frequency","activity_type","major"};
        for(Map<String,String> o : others) {
            int score = 0;
            for(String f : fields) {
                if(current.get(f)!=null && current.get(f).equalsIgnoreCase(o.get(f))) score++;
            }
            scores.put(o, score);
        }

        // Sort matches
        List<Map<String,String>> sortedMatches = new ArrayList<>(scores.keySet());
        sortedMatches.sort((a,b) -> scores.get(b) - scores.get(a));
        int displayCount = Math.min(4, sortedMatches.size());

%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>UniMatch - Top Matches</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
body {
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    background: #f8f9fa;
    color: #333;
    padding: 20px;
    min-height: 100vh;
}

/* Container */
.container {
    max-width: 1200px;
    margin: 0 auto;
}

/* Page Header */
header {
    text-align: center;
    margin-bottom: 30px;
    color: #1a73e8;
}
header h1 {
    font-size: 2.5rem;
    font-weight: 700;
}

/* Match Cards Grid */
.match-cards {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
    gap: 20px;
}

/* Individual Card */
.match-card {
    background: #fff;
    border-radius: 12px;
    padding: 20px;
    text-align: center;
    box-shadow: 0 5px 15px rgba(0,0,0,0.08);
    transition: transform 0.3s, box-shadow 0.3s;
    border-top: 5px solid #1a73e8;
}
.match-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 25px rgba(0,0,0,0.15);
}

/* Avatar Circle */
.match-circle {
    width: 80px;
    height: 80px;
    background: #1a73e8;
    color: #fff;
    font-size: 2rem;
    font-weight: bold;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    margin: 0 auto 10px;
}

/* Name & Info */
.match-name {
    font-size: 1.3rem;
    color: #1a73e8;
    margin-bottom: 5px;
}
.match-major {
    color: #ffc107;
    font-weight: 600;
    margin-bottom: 5px;
}
.match-year {
    color: #6c757d;
    margin-bottom: 10px;
}

/* Match Score Badge */
.match-score {
    display: inline-block;
    background: #ffc107;
    color: #000;
    padding: 5px 12px;
    border-radius: 20px;
    font-weight: 600;
    margin-bottom: 10px;
}

/* Match Details */
.match-details p {
    font-size: 0.95rem;
    color: #555;
    margin-bottom: 5px;
}
.match-details i {
    margin-right: 5px;
    color: #1a73e8;
}

/* Buttons */
.btn, .btn-chat, .btn-connect {
    display: inline-block;
    margin: 5px 5px 0 5px;
    padding: 8px 15px;
    background: #1a73e8;
    color: white;
    border-radius: 6px;
    text-decoration: none;
    transition: 0.2s;
}
.btn:hover, .btn-chat:hover, .btn-connect:hover {
    background: #1557b7;
}

/* Responsive */
@media (max-width: 768px) {
    .match-cards {
        grid-template-columns: 1fr;
    }
    header h1 {
        font-size: 2rem;
    }
}

</style>
</head>
<body>
<div class="container">
<header>
    <h1>Top Matches</h1>
</header>
<div class="match-cards">
<%
    for(int i=0; i<displayCount; i++) {
        Map<String,String> user = sortedMatches.get(i);
        int score = scores.get(user);
        String firstLetter = user.get("name") != null && !user.get("name").isEmpty() ? user.get("name").substring(0,1).toUpperCase() : "?";
        int percent = (int)Math.round((score*100.0)/fields.length);
%>
    <div class="match-card">
        <div class="match-circle"><%= firstLetter %></div>
        <h3 class="match-name"><%= user.get("name") %></h3>
        <p class="match-major"><%= user.get("major") %></p>
        <p class="match-year"><%= user.get("year") %> • <%= user.get("age") %> yrs</p>
        <span class="match-score"><%= percent %>% Match</span>
        <div class="match-details">
            <p><i class="fas fa-user"></i> Gender: <%= user.get("gender") %></p>
            <p><i class="fas fa-book"></i> Study Time: <%= user.get("study_time") %></p>
            <p><i class="fas fa-coffee"></i> Environment: <%= user.get("study_environment") %></p>
			<p><i class="fas fa-star"></i> Activity: <%= user.get("activity_type") %></p>
            <p><i class="fas fa-heart"></i> Hobbies: <%= user.get("hobbies") %></p>
        </div>
        <a href="chat.jsp?userId=<%= user.get("user_id") %>" class="btn-chat"><i class="fas fa-comment"></i> Chat</a>
        <a href="connect.jsp?userId=<%= user.get("user_id") %>" class="btn-connect"><i class="fas fa-user-plus"></i> Connect</a>
    </div>
<% } %>
</div>
<a href="userHome.jsp" class="btn"><i class="fas fa-home"></i> Back to Home</a>
</div>
</body>
</html>

<%
    } catch(Exception e) {
        out.println("<pre>"+e+"</pre>");
    } finally {
        try{ if(rs!=null) rs.close(); if(pst!=null) pst.close(); if(conn!=null) conn.close(); }
        catch(Exception e){ }
    }
%>
