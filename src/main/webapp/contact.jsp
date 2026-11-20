<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, com.roommatefinder.DBConnection" %>
<%
    String statusMessage = "";
    if(request.getMethod().equalsIgnoreCase("POST")) {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String messageText = request.getParameter("message");

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO contact_messages (name, email, subject, message) VALUES (?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, subject);
            ps.setString(4, messageText);
            ps.executeUpdate();
            statusMessage = "Your message has been sent successfully!";
        } catch (Exception e) {
            e.printStackTrace();
            statusMessage = "Error saving message: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us - RoommateFinder</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary: #1a73e8;
            --secondary: #6c757d;
            --success: #3cb371;
            --warning: #ff9f43;
            --danger: #ff6b6b;
            --light: #f8f9fa;
            --dark: #343a40;
            --university-blue: #1a73e8;
            --university-gold: #ffc107;
        }
        
        * { margin:0; padding:0; box-sizing:border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        body { background-color: #f9fafb; color:#333; line-height:1.6; }
        .container { width:90%; max-width:1200px; margin:0 auto; padding:20px; }

        header { background:white; box-shadow:0 2px 10px rgba(0,0,0,0.1); position:sticky; top:0; z-index:100; }
        .header-content { display:flex; justify-content:space-between; align-items:center; padding:15px 0; }
        .logo { display:flex; align-items:center; font-size:24px; font-weight:700; color: var(--university-blue); }
        .logo span { color: var(--university-gold); }
        .logo i { margin-right:10px; font-size:28px; }
        nav ul { display:flex; list-style:none; }
        nav ul li { margin-left:25px; }
        nav ul li a { font-weight:500; color:var(--dark); text-decoration: none; } 
        nav ul li a:hover, nav ul li a.active { color: var(--university-blue); }
        .nav-buttons { display:flex; gap:10px; }
        .btn { display:inline-block; padding:10px 20px; background:var(--university-blue); color:white; border-radius:4px; font-weight:600; border:none; cursor:pointer; text-align:center;text-decoration:none;}
        .btn:hover { background:#1557b7; transform:translateY(-2px); }
        .btn-outline { background:transparent; border:2px solid var(--university-blue); color:var(--university-blue);}
        .btn-outline:hover { background:var(--university-blue); color:white; }

        .hero { padding:80px 0; background: linear-gradient(135deg, rgba(26, 115, 232, 0.9) 0%, rgba(26, 115, 232, 0.8) 100%), url('https://images.unsplash.com/photo-1516387938699-a93567ec168e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80'); background-size: cover; background-position: center; color:white; text-align:center; border-radius:8px; margin:40px 0; }
        .hero h1 { font-size:42px; margin-bottom:20px; }
        .hero p { font-size:18px; max-width:600px; margin:0 auto 40px; opacity:0.9; }

        .contact-section { padding:60px 0; }
        .section-title { text-align:center; font-size:36px; margin-bottom:50px; color: var(--university-blue); }
        .contact-container { display:grid; grid-template-columns:1fr 1fr; gap:40px; }
        .contact-info, .contact-form { background:white; padding:40px; border-radius:8px; box-shadow:0 5px 15px rgba(0,0,0,0.05); }
        .contact-info h2, .contact-form h2 { margin-bottom:30px; color: var(--university-blue); }
        .contact-detail { display:flex; align-items:flex-start; margin-bottom:25px; }
        .contact-icon { width:50px; height:50px; background: var(--light); border-radius:50%; display:flex; align-items:center; justify-content:center; margin-right:15px; color: var(--university-blue); font-size:20px; }
        .contact-text h3 { margin-bottom:5px; }
        .contact-text p { color: var(--secondary); }
        .form-group { margin-bottom:20px; }
        .form-group label { display:block; margin-bottom:8px; font-weight:500; }
        .form-group input, .form-group textarea, .form-group select { width:100%; padding:12px 15px; border:1px solid #ddd; border-radius:4px; font-size:16px; }
        .form-group textarea { min-height:150px; resize:vertical; }

        .map-section { padding:40px 0; }
        .map-container { height:400px; border-radius:8px; overflow:hidden; }

        .faq-section { padding:60px 0; background:#f0f5ff; border-radius:8px; margin:40px 0; }
        .faq-item { background:white; border-radius:8px; margin-bottom:20px; overflow:hidden; box-shadow:0 5px 15px rgba(0,0,0,0.05); }
        .faq-question { padding:20px; cursor:pointer; display:flex; justify-content:space-between; align-items:center; font-weight:600; }
        .faq-question i { transition: transform 0.3s; }
        .faq-answer { padding:0 20px; max-height:0; overflow:hidden; transition: max-height 0.3s, padding 0.3s; }
        .faq-item.active .faq-answer { max-height:500px; padding:0 20px 20px; }
        .faq-item.active .faq-question i { transform:rotate(180deg); }

        footer { background: var(--dark); color:white; padding:60px 0 30px; margin-top:60px; }
        .footer-content { display:grid; grid-template-columns:repeat(auto-fit, minmax(200px,1fr)); gap:40px; margin-bottom:40px; }
        .footer-column h3 { margin-bottom:20px; position:relative; padding-bottom:10px; }
        .footer-column h3::after { content:''; position:absolute; left:0; bottom:0; width:40px; height:2px; background: var(--university-blue); }
        .footer-column ul { list-style:none; }
        .footer-column ul li { margin-bottom:12px; }
        .footer-column a { color:#e2e8f0; text-decoration: none; } 
        .footer-column a:hover { color:white; }
        .footer-social { display:flex; gap:15px; margin-top:20px; }
        .footer-social a { display:flex; align-items:center; justify-content:center; width:40px; height:40px; border-radius:50%; background: rgba(255,255,255,0.1); }
        .footer-social a:hover { background: var(--university-blue); }
        .footer-bottom { text-align:center; padding-top:30px; border-top:1px solid rgba(255,255,255,0.1); }

        @media (max-width:968px) { .contact-container { grid-template-columns:1fr; } }
        @media (max-width:768px) { 
            .header-content { flex-direction:column; text-align:center; } 
            nav ul { margin:20px 0; justify-content:center; flex-wrap:wrap; } 
            nav ul li { margin:0 10px 10px; } 
            .hero h1 { font-size:32px; } 
            .section-title { font-size:28px; } 
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <div class="container header-content">
            <div class="logo"><i class="fas fa-house-user"></i>Roommate<span>Finder</span></div>
            <nav>
                <ul>
                    <li><a href="index.jsp">Home</a></li>
                    <li><a href="aboutus.jsp">About Us</a></li>
                    <li><a href="contact.jsp" class="active">Contact</a></li>
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
            <h1>Contact RoommateFinder</h1>
            <p>We're here to help you find your perfect roommate match</p>
        </div>
    </div>

    <!-- Contact Section -->
    <section class="contact-section">
        <div class="container">
            <h2 class="section-title">Get In Touch</h2>
            <div class="contact-container">
                <!-- Contact Info -->
                <div class="contact-info">
                    <h2>Contact Information</h2>
                    <div class="contact-detail"><div class="contact-icon"><i class="fas fa-map-marker-alt"></i></div><div class="contact-text"><h3>Address</h3><p>University of Information Technology<br>Hlaing Township, Yangon, Myanmar</p></div></div>
                    <div class="contact-detail"><div class="contact-icon"><i class="fas fa-phone"></i></div><div class="contact-text"><h3>Phone</h3><p>+95 9666044997</p></div></div>
                    <div class="contact-detail"><div class="contact-icon"><i class="fas fa-envelope"></i></div><div class="contact-text"><h3>Email</h3><p>admin@gmail.com</p></div></div>
                    <div class="contact-detail"><div class="contact-icon"><i class="fas fa-clock"></i></div><div class="contact-text"><h3>Hours</h3><p>Monday-Friday: 9am - 5pm<br>Saturday: 10am - 2pm<br>Sunday: Closed</p></div></div>
                </div>

                <!-- Contact Form -->
                <div class="contact-form">
                    <h2>Send Us a Message</h2>
                    <% if(!statusMessage.isEmpty()) { %>
                        <div style="color:green;font-weight:bold;margin-bottom:15px;"><%= statusMessage %></div>
                    <% } %>
                    <form id="contactForm" method="post">
                        <div class="form-group"><label for="name">Your Name</label><input type="text" id="name" name="name" placeholder="Enter your name" required></div>
                        <div class="form-group"><label for="email">Email Address</label><input type="email" id="email" name="email" placeholder="Enter your email" required></div>
                        <div class="form-group"><label for="subject">Subject</label><select id="subject" name="subject" required>
                            <option value="">Select a subject</option>
                            <option value="general">General Inquiry</option>
                            <option value="support">Technical Support</option>
                            <option value="partnership">Partnership Opportunity</option>
                            <option value="feedback">Feedback</option>
                            <option value="report">Report an Issue</option>
                            <option value="other">Other</option>
                        </select></div>
                        <div class="form-group"><label for="message">Message</label><textarea id="message" name="message" placeholder="How can we help you?" required></textarea></div>
                        <button type="submit" class="btn" style="width:100%;">Send Message</button>
                    </form>
                </div>
            </div>
        </div>
    </section>

    <!-- Map Section -->
    <section class="map-section">
        <div class="container">
            <h2 class="section-title">Our Location</h2>
            <div class="map-container">
                <iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3818.453126420776!2d96.13317831526302!3d16.8559165!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x30c1936f625d4ba7%3A0x9676670831769962!2sUniversity+of+Information+Technology!5e0!3m2!1sen!2smm!4v1633018912345!5m2!1sen!2smm" width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"></iframe>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="container">
            <div class="footer-content">
                <div class="footer-column"><h3>RoommateFinder</h3><p>Helping university students find compatible roommates since 2023.</p></div>
                <div class="footer-column"><h3>Quick Links</h3><ul><li><a href="index.jsp">Home</a></li><li><a href="matches.jsp">Matches</a></li><li><a href="about.jsp">About Us</a></li><li><a href="contact.jsp">Contact</a></li></ul></div>
                <div class="footer-column"><h3>Resources</h3><ul><li><a href="#">Blog</a></li><li><a href="#">Roommate Tips</a></li><li><a href="#">University Housing</a></li><li><a href="#">FAQ</a></li></ul></div>
                <div class="footer-column"><h3>Legal</h3><ul><li><a href="#">Terms of Service</a></li><li><a href="#">Privacy Policy</a></li><li><a href="#">Cookie Policy</a></li></ul></div>
            </div>
            <div class="footer-bottom"><p>&copy; <%= java.time.Year.now() %> RoommateFinder. All rights reserved.</p></div>
        </div>
    </footer>

    <script>
        document.querySelectorAll('.faq-question').forEach(question => {
            question.addEventListener('click', () => {
            	const item = question.parentElement;
            	item.classList.toggle('active');
            });
           
        });
    </script>
</body>
</html>
