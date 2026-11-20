<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>About Us - RoommateFinder</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root {
    --primary: #1a73e8;
    --secondary: #6c757d;
    --light: #f8f9fa;
    --dark: #343a40;
    --gold: #ffc107;
}
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}
body {
    background-color: #f9fafb;
    color: #333;
    line-height: 1.6;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
}
.container {
    width: 90%;
    max-width: 1200px;
    margin: 0 auto;
    padding: 20px;
}

/* Header */
header {
    background: white;
    box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    position: sticky;
    top: 0;
    z-index: 100;
}
.header-content {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 15px 0;
    flex-wrap: wrap;
}
.logo { display: flex; align-items: center; font-size: 24px; font-weight: 700; color: var(--primary); }
.logo span { color: var(--gold); }
.logo i { margin-right: 10px; font-size: 28px; }
nav ul { display: flex; list-style: none; flex-wrap: wrap; }
nav ul li { margin-left: 20px; }
nav ul li a { font-weight: 500; color: var(--dark); text-decoration: none; transition: color 0.3s; }
nav ul li a:hover, nav ul li a.active { color: var(--primary); }
.nav-buttons { display: flex; gap: 10px; }
.btn { display: inline-block; padding: 10px 20px; background: var(--primary); color: white; border-radius: 4px; font-weight: 600; border: none; cursor: pointer; transition: all 0.3s ease; text-decoration: none; text-align: center; }
.btn:hover { background: #1557b7; transform: translateY(-2px); }
.btn-outline { background: transparent; border: 2px solid var(--primary); color: var(--primary); }
.btn-outline:hover { background: var(--primary); color: white; }

/* Hero */
.hero { padding: 80px 20px; background: linear-gradient(135deg, rgba(26, 115, 232, 0.85) 0%, rgba(26, 115, 232, 0.8) 100%), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'); background-size: cover; background-position: center; color: white; text-align: center; border-radius: 8px; margin: 40px 0; }
.hero h1 { font-size: 42px; margin-bottom: 20px; }
.hero p { font-size: 18px; max-width: 600px; margin: 0 auto 30px; opacity: 0.9; }

/* About Section */
.about-section { padding: 60px 0; }
.section-title { text-align: center; font-size: 36px; margin-bottom: 50px; color: var(--primary); }
.about-content { display: grid; grid-template-columns: 1fr 1fr; gap: 40px; align-items: center; }
.about-text h2 { font-size: 28px; margin-bottom: 20px; color: var(--primary); }
.about-text p { margin-bottom: 20px; line-height: 1.8; }
.about-image { border-radius: 8px; overflow: hidden; box-shadow: 0 10px 30px rgba(0,0,0,0.1); }
.about-image div { display: flex; align-items: center; justify-content: center; flex-direction: column; height: 100%; padding: 40px; color: white; font-size: 24px; background: var(--primary); }

/* Mission Section */
.mission-section { padding: 60px 0; background: #f0f5ff; border-radius: 8px; }
.mission-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 30px; }
.mission-card { background: white; padding: 30px 20px; border-radius: 8px; text-align: center; box-shadow: 0 5px 15px rgba(0,0,0,0.05); transition: transform 0.3s; }
.mission-card:hover { transform: translateY(-10px); }
.mission-icon { font-size: 50px; margin-bottom: 15px; color: var(--primary); }
.mission-card h3 { margin-bottom: 10px; color: var(--primary); }

/* Team Section */
.team-section { padding: 60px 0; }
.team-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); gap: 30px; }
.team-member { background: white; border-radius: 8px; overflow: hidden; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-align: center; transition: transform 0.3s; }
.team-member:hover { transform: translateY(-5px); }
.member-image { height: 200px; display: flex; align-items: center; justify-content: center; background: var(--primary); color: white; font-size: 80px; }
.member-info { padding: 20px; }
.member-info h3 { margin-bottom: 10px; color: var(--primary); }
.member-info p { color: var(--secondary); margin-bottom: 10px; }
.social-links a { display: inline-flex; align-items: center; justify-content: center; width: 35px; height: 35px; border-radius: 50%; background: #f0f0f0; color: var(--primary); margin: 0 5px; transition: all 0.3s; }
.social-links a:hover { background: var(--primary); color: white; }

/* Footer */
footer { background: var(--dark); color: white; padding: 60px 0 30px; margin-top: auto; }
.footer-content { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 40px; margin-bottom: 40px; }
.footer-column h3 { margin-bottom: 20px; position: relative; padding-bottom: 10px; }
.footer-column h3::after { content: ''; position: absolute; left: 0; bottom: 0; width: 40px; height: 2px; background: var(--primary); }
.footer-column ul { list-style: none; }
.footer-column ul li { margin-bottom: 12px; }
.footer-column a { color: #e2e8f0; text-decoration: none; transition: color 0.3s; }
.footer-column a:hover { color: white; }
.footer-social { display: flex; gap: 15px; margin-top: 10px; }
.footer-social a { display: flex; align-items: center; justify-content: center; width: 35px; height: 35px; border-radius: 50%; background: rgba(255,255,255,0.1); transition: all 0.3s; }
.footer-social a:hover { background: var(--primary); }
.footer-bottom { text-align: center; padding-top: 20px; border-top: 1px solid rgba(255,255,255,0.1); }

/* Responsive */
@media (max-width: 968px) { .about-content { grid-template-columns: 1fr; } }
@media (max-width: 768px) {
    .header-content { flex-direction: column; text-align: center; }
    nav ul { justify-content: center; margin: 20px 0; flex-wrap: wrap; }
    nav ul li { margin: 5px 10px; }
    .hero h1 { font-size: 32px; }
    .section-title { font-size: 28px; }
}
</style>
</head>
<body>

<!-- Header -->
<header>
<div class="container header-content">
    <div class="logo"><i class="fas fa-house-user"></i> Roommate<span>Finder</span></div>
    <nav>
        <ul>
            <li><a href="index.jsp">Home</a></li>
            <li><a href="aboutus.jsp" class="active">About Us</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="faq.jsp" >FAQ</a></li>
        </ul>
    </nav>
    <div class="nav-buttons">
        <a href="login.jsp" class="btn btn-outline">Login</a>
        <a href="register.jsp" class="btn">Register</a>
    </div>
</div>
</header>

<!-- Hero -->
<div class="container">
    <div class="hero">
        <h1>About RoommateFinder</h1>
        <p>Connecting students with compatible roommates for a better university experience</p>
    </div>
</div>

<!-- About Section -->
<section class="about-section">
<div class="container">
<h2 class="section-title">Our Story</h2>
<div class="about-content">
    <div class="about-text">
        <h2>Making University Life Easier</h2>
        <p>RoommateFinder was founded in 2023 by students who faced challenges finding compatible roommates. Our platform matches users based on habits, schedules, and interests.</p>
        <p>We aim to help students not only find roommates but build positive, lasting connections.</p>
        <a href="register.jsp" class="btn">Join Our Community</a>
    </div>
    <div class="about-image">
        <div><i class="fas fa-users" style="font-size: 80px; margin-bottom: 20px;"></i>Students connected through our platform</div>
    </div>
</div>
</div>
</section>

<!-- Mission Section -->
<section class="mission-section">
<div class="container">
<h2 class="section-title">Our Mission & Values</h2>
<div class="mission-grid">
<div class="mission-card"><div class="mission-icon"><i class="fas fa-heart"></i></div><h3>Compatibility</h3><p>We focus on matching students based on compatibility to ensure harmonious living.</p></div>
<div class="mission-card"><div class="mission-icon"><i class="fas fa-graduation-cap"></i></div><h3>Academic Success</h3><p>We support living arrangements that enhance students’ academic performance.</p></div>
<div class="mission-card"><div class="mission-icon"><i class="fas fa-shield-alt"></i></div><h3>Safety & Trust</h3><p>We prioritize user safety through verification and community guidelines.</p></div>
</div>
</div>
</section>

<!-- Team Section -->
<section class="team-section">
<div class="container">
<h2 class="section-title">Our Team</h2>
<div class="team-grid">
<!-- 4 Team Members -->
<div class="team-member"><div class="member-image"><i class="fas fa-user"></i></div><div class="member-info"><h3>Khant Khant Wadi Hlaing</h3><div class="social-links"><a href="#"><i class="fab fa-linkedin"></i></a><a href="#"><i class="fab fa-twitter"></i></a><a href="#"><i class="fas fa-envelope"></i></a></div></div></div>
<div class="team-member"><div class="member-image"><i class="fas fa-user"></i></div><div class="member-info"><h3>Hlaing Htet Htet Tun</h3><div class="social-links"><a href="#"><i class="fab fa-linkedin"></i></a><a href="#"><i class="fab fa-twitter"></i></a><a href="#"><i class="fas fa-envelope"></i></a></div></div></div>
<div class="team-member"><div class="member-image"><i class="fas fa-user"></i></div><div class="member-info"><h3>Thet Hmue Thaw</h3><div class="social-links"><a href="#"><i class="fab fa-linkedin"></i></a><a href="#"><i class="fab fa-twitter"></i></a><a href="#"><i class="fas fa-envelope"></i></a></div></div></div>
<div class="team-member"><div class="member-image"><i class="fas fa-user"></i></div><div class="member-info"><h3>Zaw Paing Htet</h3><div class="social-links"><a href="#"><i class="fab fa-linkedin"></i></a><a href="#"><i class="fab fa-twitter"></i></a><a href="#"><i class="fas fa-envelope"></i></a></div></div></div>
</div>
</div>
</section>

<!-- Footer -->
<footer>
<div class="container">
<div class="footer-content">
<div class="footer-column"><h3>RoommateFinder</h3><p>Helping university students find compatible roommates since 2023.</p>
<div class="footer-social"><a href="#"><i class="fab fa-facebook-f"></i></a><a href="#"><i class="fab fa-twitter"></i></a><a href="#"><i class="fab fa-instagram"></i></a><a href="#"><i class="fab fa-linkedin-in"></i></a></div></div>
<div class="footer-column"><h3>Quick Links</h3><ul><li><a href="index.jsp">Home</a></li><li><a href="matches.jsp">Find Matches</a></li><li><a href="aboutus.jsp">About Us</a></li><li><a href="contact.jsp">Contact</a></li></ul></div>
<div class="footer-column"><h3>Resources</h3><ul><li><a href="#">Blog</a></li><li><a href="#">Roommate Tips</a></li><li><a href="#">University Housing</a></li><li><a href="#">FAQ</a></li></ul></div>
<div class="footer-column"><h3>Legal</h3><ul><li><a href="#">Terms of Service</a></li><li><a href="#">Privacy Policy</a></li><li><a href="#">Cookie Policy</a></li></ul></div>
</div>
<div class="footer-bottom">© <%= java.time.Year.now() %> RoommateFinder. All rights reserved.</div>
</div>
</footer>

</body>
</html>
