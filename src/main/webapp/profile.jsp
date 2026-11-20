<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>
<%
    String username = (String) session.getAttribute("username");
    if (username == null) { response.sendRedirect("login.jsp"); return; }

    String successMsg = request.getParameter("success");
    String errorMsg = request.getParameter("error");

    // Initialize profile variables
    String firstName="", lastName="", email="", phone="", gender="", bio="", major="";
    int age=0;
    String cleanliness="Average", sleepSchedule="Standard (7 AM - 9 AM)", smoking="Non-smoker", overnightGuests="Never";
    String preferredGender="No preference";
    int ageMin=18, ageMax=99;
    double budget=0;
    String location="", mustHave="";
    boolean showEmail=true, showPhone=true, showProfile=true;

    // Fetch profile data
    try (Connection conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3308/roommatefinder","root","")) {
        String sql = "SELECT * FROM users WHERE username=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    firstName = rs.getString("first_name") != null ? rs.getString("first_name") : "";
                    lastName = rs.getString("last_name") != null ? rs.getString("last_name") : "";
                    email = rs.getString("email") != null ? rs.getString("email") : "";
                    phone = rs.getString("phone") != null ? rs.getString("phone") : "";
                    age = rs.getInt("age");
                    gender = rs.getString("gender") != null ? rs.getString("gender") : "";
                    bio = rs.getString("bio") != null ? rs.getString("bio") : "";
                    major = rs.getString("major") != null ? rs.getString("major") : "";

                    cleanliness = rs.getString("cleanliness") != null ? rs.getString("cleanliness") : cleanliness;
                    sleepSchedule = rs.getString("sleep_schedule") != null ? rs.getString("sleep_schedule") : sleepSchedule;
                    smoking = rs.getString("smoking") != null ? rs.getString("smoking") : smoking;
                    overnightGuests = rs.getString("overnight_guests") != null ? rs.getString("overnight_guests") : overnightGuests;

                    preferredGender = rs.getString("preferred_gender") != null ? rs.getString("preferred_gender") : preferredGender;
                    ageMin = rs.getInt("age_min") != 0 ? rs.getInt("age_min") : ageMin;
                    ageMax = rs.getInt("age_max") != 0 ? rs.getInt("age_max") : ageMax;
                    budget = rs.getDouble("budget");
                    location = rs.getString("location") != null ? rs.getString("location") : "";
                    mustHave = rs.getString("must_have") != null ? rs.getString("must_have") : "";

                    showEmail = rs.getBoolean("show_email");
                    showPhone = rs.getBoolean("show_phone");
                    showProfile = rs.getBoolean("show_profile");
                }
            }
        }
    } catch(Exception e){ e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Profile - <%=username%></title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root { --primary:#1a73e8; --secondary:#6c757d; --light:#f8f9fa; --dark:#343a40; --gold:#ffc107; }
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
body { background:#f9fafb; color:#333; min-height:100vh; }
.container { width:90%; max-width:1200px; margin:0 auto; padding:20px; }
header { background:white; box-shadow:0 2px 10px rgba(0,0,0,0.1); position:sticky; top:0; z-index:100; }
.header-content { display:flex; justify-content:space-between; align-items:center; padding:15px 0; flex-wrap:wrap; }
.logo { display:flex; align-items:center; font-size:24px; font-weight:700; color:var(--primary); }
.logo span { color:var(--gold); }
.logo i { margin-right:10px; font-size:28px; }
nav ul { display:flex; list-style:none; flex-wrap:wrap; }
nav ul li { margin-left:20px; }
nav ul li a { font-weight:500; color:var(--dark); text-decoration:none; transition:color 0.3s; }
nav ul li a:hover, nav ul li a.active { color:var(--primary); }
.btn { display:inline-block; padding:12px 25px; font-size:16px; font-weight:600; border-radius:8px; border:none; cursor:pointer; text-align:center; text-decoration:none; transition: all 0.3s ease; }
.btn-primary { background-color: var(--primary); color: #fff; }
.btn-primary:hover { background-color: #1557b7; transform: translateY(-2px); box-shadow: 0 6px 8px rgba(0,0,0,0.15); }
.btn-outline { background-color: transparent; border: 2px solid var(--primary); color: var(--primary); }
.btn-outline:hover { background-color: var(--primary); color: #fff; transform: translateY(-2px); box-shadow: 0 6px 8px rgba(0,0,0,0.1); }
.form-actions { display: flex; justify-content: flex-end; gap: 15px; margin-top: 25px; }
.main-content { display:flex; margin-top:30px; gap:30px; }
.sidebar { width:250px; background:white; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,0.08); padding:20px; }
.profile-card{text-align:center;margin-bottom:20px;}
.profile-avatar{width:100px;height:100px;border-radius:50%;border:4px solid var(--primary);margin:0 auto 15px;display:flex;align-items:center;justify-content:center;font-weight:bold;font-size:36px;color:white; background:var(--gold);}
.sidebar-menu{list-style:none;}
.sidebar-menu li{margin-bottom:10px;}
.sidebar-menu a{display:block;padding:10px 15px;color:var(--dark);text-decoration:none;border-radius:5px;transition:all 0.3s; cursor:pointer;}
.sidebar-menu a:hover,.sidebar-menu a.active{background-color:var(--primary);color:white;}
.sidebar-menu i{margin-right:10px;width:20px;text-align:center;}
.content{flex:1;background:white;border-radius:10px;box-shadow:0 5px 15px rgba(0,0,0,0.08);padding:30px;}
.content-header{display:flex;justify-content:space-between;align-items:center;margin-bottom:20px;padding-bottom:15px;border-bottom:1px solid #e9ecef;}
.content-header h1{color:var(--secondary);}
.success-msg{color:green;margin-bottom:15px;font-size:14px;}
.error-msg{color:red;margin-bottom:15px;font-size:14px;}
.form-section{margin-bottom:30px;}
.form-section h2{color:var(--secondary);margin-bottom:20px;padding-bottom:10px;border-bottom:2px solid #e9ecef;}
.form-grid{display:grid;grid-template-columns:repeat(2,1fr);gap:20px;}
.form-group{margin-bottom:20px;}
.form-group label{display:block;margin-bottom:8px;font-weight:600;color:var(--secondary);}
.form-control{width:100%;padding:12px 15px;border:1px solid #e9ecef;border-radius:5px;font-size:16px;transition:border-color 0.3s;}
.form-control:focus{border-color:var(--primary);outline:none;box-shadow:0 0 0 3px rgba(26,115,232,0.2);}
textarea.form-control{min-height:100px;resize:vertical;}
@media(max-width:992px){.main-content{flex-direction:column;}.sidebar{width:100%;}}
</style>
</head>
<body>

<header>
    <div class="container header-content">
        <div class="logo"><i class="fas fa-house-user"></i> Roommate<span>Finder</span></div>
        <nav>
            <ul>
                <li><a href="userHome.jsp" class="nav-link">Home</a></li>
                <li><a href="findMatch.jsp" class="nav-link">FindMatch</a></li>
                <li><a href="chat.jsp" class="nav-link">Message</a></li>
                <li><a href="connections.jsp" class="nav-link">Request</a></li>
                <li><a href="profile.jsp" class="nav-link active">Profile</a></li>
                <li><a href="complain.jsp" class="nav-link">Complaint</a></li>
                <li><a href="logout.jsp" class="nav-link">Logout</a></li>
            </ul>
        </nav>
    </div>
</header>

<div class="container main-content">
    <div class="sidebar">
        <div class="profile-card">
            <div class="profile-avatar"><%= username.substring(0,1).toUpperCase() %></div>
            <h3><%= username %></h3>
        </div>
        <ul class="sidebar-menu">
            <li><a class="tab-link active" data-tab="info"><i class="fas fa-user"></i> Profile Information</a></li>
            <li><a class="tab-link" data-tab="preferences"><i class="fas fa-sliders-h"></i> Roommate Preferences</a></li>
            <li><a class="tab-link" data-tab="privacy"><i class="fas fa-lock"></i> Privacy Settings</a></li>
        </ul>
    </div>

    <div class="content">
        <% if(successMsg != null){ %><div class="success-msg"><%=successMsg%></div><% } %>
        <% if(errorMsg != null){ %><div class="error-msg"><%=errorMsg%></div><% } %>

        <!-- Profile Information Tab -->
        <div class="tab-content" id="info">
            <div class="content-header"><h1>Edit Profile</h1></div>
            <form action="saveProfile.jsp" method="post">
                <div class="form-section">
                    <h2>Basic Information</h2>
                    <div class="form-grid">
                        <div class="form-group"><label>First Name</label><input type="text" name="firstName" class="form-control" value="<%= firstName %>"></div>
                        <div class="form-group"><label>Last Name</label><input type="text" name="lastName" class="form-control" value="<%= lastName %>"></div>
                        <div class="form-group"><label>Email</label><input type="email" name="email" class="form-control" value="<%= email %>"></div>
                        <div class="form-group"><label>Phone</label><input type="text" name="phone" class="form-control" value="<%= phone %>"></div>
                        <div class="form-group"><label>Age</label><input type="number" name="age" class="form-control" value="<%= age %>"></div>
                        <div class="form-group"><label>Gender</label>
                            <select name="gender" class="form-control">
                                <option <%= "Female".equals(gender)?"selected":"" %>>Female</option>
                                <option <%= "Male".equals(gender)?"selected":"" %>>Male</option>
                                <option <%= "Non-binary".equals(gender)?"selected":"" %>>Non-binary</option>
                                <option <%= "Prefer not to say".equals(gender)?"selected":"" %>>Prefer not to say</option>
                            </select>
                        </div>
                        <div class="form-group"><label>Major</label><input type="text" name="major" class="form-control" value="<%= major %>"></div>
                        <div class="form-group" style="grid-column:span 2;">
                            <label>Bio</label>
                            <textarea name="bio" class="form-control"><%= bio %></textarea>
                        </div>
                    </div>
                </div>
                <div class="form-actions">
                    <a href="userHome.jsp" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                </div>
            </form>
        </div>

        <!-- Preferences Tab -->
        <div class="tab-content" id="preferences" style="display:none;">
            <div class="content-header"><h1>Lifestyle & Roommate Preferences</h1></div>
            <form action="savePreferences.jsp" method="post">
                <div class="form-section">
                    <h2>Lifestyle Preferences</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Cleanliness</label>
                            <select name="cleanliness" class="form-control">
                                <option <%= "Very Clean".equals(cleanliness)?"selected":"" %>>Very Clean</option>
                                <option <%= "Clean".equals(cleanliness)?"selected":"" %>>Clean</option>
                                <option <%= "Average".equals(cleanliness)?"selected":"" %>>Average</option>
                                <option <%= "Messy".equals(cleanliness)?"selected":"" %>>Messy</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Sleep Schedule</label>
                            <select name="sleepSchedule" class="form-control">
                                <option <%= "Early Riser (before 7 AM)".equals(sleepSchedule)?"selected":"" %>>Early Riser (before 7 AM)</option>
                                <option <%= "Standard (7 AM - 9 AM)".equals(sleepSchedule)?"selected":"" %>>Standard (7 AM - 9 AM)</option>
                                <option <%= "Night Owl (after 9 AM)".equals(sleepSchedule)?"selected":"" %>>Night Owl (after 9 AM)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Smoking</label>
                            <select name="smoking" class="form-control">
                                <option <%= "Non-smoker".equals(smoking)?"selected":"" %>>Non-smoker</option>
                                <option <%= "Social smoker".equals(smoking)?"selected":"" %>>Social smoker</option>
                                <option <%= "Smoker".equals(smoking)?"selected":"" %>>Smoker</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Overnight Guests</label>
                            <select name="overnightGuests" class="form-control">
                                <option <%= "Often".equals(overnightGuests)?"selected":"" %>>Often</option>
                                <option <%= "Sometimes".equals(overnightGuests)?"selected":"" %>>Sometimes</option>
                                <option <%= "Rarely".equals(overnightGuests)?"selected":"" %>>Rarely</option>
                                <option <%= "Never".equals(overnightGuests)?"selected":"" %>>Never</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <h2>Roommate Preferences</h2>
                    <div class="form-grid">
                        <div class="form-group">
                            <label>Preferred Gender</label>
                            <select name="preferredGender" class="form-control">
                                <option <%= "No preference".equals(preferredGender)?"selected":"" %>>No preference</option>
                                <option <%= "Female".equals(preferredGender)?"selected":"" %>>Female</option>
                                <option <%= "Male".equals(preferredGender)?"selected":"" %>>Male</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Age Range</label>
                            <input type="number" name="ageMin" class="form-control" value="<%= ageMin %>" placeholder="Min"> -
                            <input type="number" name="ageMax" class="form-control" value="<%= ageMax %>" placeholder="Max">
                        </div>
                        <div class="form-group"><label>Maximum Budget</label>
                            <input type="number" name="budget" class="form-control" value="<%= budget %>" step="0.01">
                        </div>
                        <div class="form-group"><label>Location Preference</label>
                            <input type="text" name="location" class="form-control" value="<%= location %>">
                        </div>
                        <div class="form-group">
                            <label>Must Have</label>
                            <input type="text" name="mustHave" class="form-control" value="<%= mustHave %>" placeholder="Comma-separated (e.g., Non-smoker,Pet-friendly,Quiet)">
                        </div>
                    </div>
                </div>

                <div class="form-actions">
                    <a href="userHome.jsp" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save Preferences</button>
                </div>
            </form>
        </div>

        <!-- Privacy Tab -->
        <div class="tab-content" id="privacy" style="display:none;">
            <div class="content-header"><h1>Privacy Settings</h1></div>
            <form action="savePrivacy.jsp" method="post">
                <div class="form-section">
                    <h2>Privacy Options</h2>
                    <div class="form-group"><label><input type="checkbox" name="showEmail" <%= showEmail?"checked":"" %>> Show Email</label></div>
                    <div class="form-group"><label><input type="checkbox" name="showPhone" <%= showPhone?"checked":"" %>> Show Phone</label></div>
                    <div class="form-group"><label><input type="checkbox" name="showProfile" <%= showProfile?"checked":"" %>> Show Profile to others</label></div>
                </div>
                <div class="form-actions">
                    <a href="userHome.jsp" class="btn btn-outline">Cancel</a>
                    <button type="submit" class="btn btn-primary">Save Privacy</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
const tabLinks = document.querySelectorAll(".tab-link");
const tabContents = document.querySelectorAll(".tab-content");
tabLinks.forEach(tab => {
    tab.addEventListener("click", () => {
        const target = tab.getAttribute("data-tab");
        tabContents.forEach(c => c.style.display = "none");
        document.getElementById(target).style.display = "block";
        tabLinks.forEach(t => t.classList.remove("active"));
        tab.classList.add("active");
    });
});
</script>

</body>
</html>
