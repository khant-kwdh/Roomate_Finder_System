<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<%
    String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>RoommateFinder - FAQ</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<style>
:root { --primary:#1a73e8; --secondary:#6c757d; --light:#f8f9fa; --dark:#343a40; --gold:#ffc107; }
* { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',Tahoma,Geneva,Verdana,sans-serif; }
body { background:#f9fafb; color:#333; min-height:100vh; display:flex; flex-direction:column; }
.container { width:90%; max-width:1200px; margin:0 auto; padding:20px; }

/* Header */
header { background:white; box-shadow:0 2px 10px rgba(0,0,0,0.1); position:sticky; top:0; z-index:100; }
.header-content { display:flex; justify-content:space-between; align-items:center; padding:15px 0; flex-wrap:wrap; }
.logo { display:flex; align-items:center; font-size:24px; font-weight:700; color:var(--primary); }
.logo span { color:var(--gold); }
.logo i { margin-right:10px; font-size:28px; }
nav ul { display:flex; list-style:none; flex-wrap:wrap; }
nav ul li { margin-left:20px; }
nav ul li a { font-weight:500; color:var(--dark); text-decoration:none; transition:color 0.3s; }
nav ul li a:hover, nav ul li a.active { color:var(--primary); }
.nav-buttons { display:flex; gap:10px; }
.btn { display:inline-block; padding:10px 20px; background:var(--primary); color:white; border-radius:4px; font-weight:600; border:none; cursor:pointer; transition:all 0.3s ease; text-decoration:none; text-align:center; }
.btn:hover { background:#1557b7; transform:translateY(-2px); }
.btn-outline { background:transparent; border:2px solid var(--primary); color:var(--primary); }
.btn-outline:hover { background:var(--primary); color:white; }

/* Hero */
.hero { padding:60px 20px; background:linear-gradient(135deg, rgba(26,115,232,0.85), rgba(26,115,232,0.8)), url('https://images.unsplash.com/photo-1523050854058-8df90110c9f1?auto=format&fit=crop&w=1200&q=80'); background-size:cover; background-position:center; color:white; text-align:center; border-radius:8px; margin:40px 0; }
.hero h1 { font-size:38px; margin-bottom:15px; }
.hero p { font-size:18px; max-width:600px; margin:0 auto 25px; opacity:0.9; }

/* FAQ */
.faq-container { background:white; padding:30px; border-radius:8px; box-shadow:0 5px 15px rgba(0,0,0,0.05); margin-bottom:40px; }
.input-group { display:flex; justify-content:center; margin-bottom:30px; }
#faqSearch { border-radius:20px 0 0 20px; padding:12px 20px; border:1px solid #ccc; flex:1; }
#faqSearch:focus { outline:none; border-color:var(--primary); }
.btn-search { border-radius:0 20px 20px 0; padding:12px 20px; background:var(--primary); border:none; color:white; }
.category-title { color:var(--primary); font-weight:600; border-bottom:2px solid var(--primary); padding-bottom:10px; margin-top:30px; margin-bottom:15px; }
.accordion-item { margin-bottom:10px; border-radius:6px; box-shadow:0 3px 6px rgba(0,0,0,0.05); overflow:hidden; }
.accordion-button { font-weight:500; padding:1rem 1.25rem; }
.accordion-button:not(.collapsed) { background-color:var(--light); color:var(--primary); }
.accordion-body { background-color:#f8f9fa; padding:1.5rem; }

/* Support Card */
.support-card { border:none; border-radius:10px; box-shadow:0 5px 15px rgba(0,0,0,0.08); margin-top:40px; padding:40px; text-align:center; }
.support-icon { font-size:3rem; color:var(--primary); }

/* Footer */
footer { background:var(--dark); color:white; padding:60px 0 30px; margin-top:auto; }
.footer-content { display:grid; grid-template-columns:repeat(auto-fit,minmax(200px,1fr)); gap:40px; margin-bottom:40px; }
.footer-column h3 { margin-bottom:20px; position:relative; padding-bottom:10px; }
.footer-column h3::after { content:''; position:absolute; left:0; bottom:0; width:40px; height:2px; background:var(--primary); }
.footer-column ul { list-style:none; }
.footer-column ul li { margin-bottom:12px; }
.footer-column a { color:#e2e8f0; text-decoration:none; transition:color 0.3s; }
.footer-column a:hover { color:white; }
.footer-social { display:flex; gap:15px; margin-top:10px; }
.footer-social a { display:flex; align-items:center; justify-content:center; width:35px; height:35px; border-radius:50%; background:rgba(255,255,255,0.1); transition:all 0.3s; }
.footer-social a:hover { background:var(--primary); }
.footer-bottom { text-align:center; padding-top:20px; border-top:1px solid rgba(255,255,255,0.1); }

/* Responsive */
@media(max-width:768px){
    .header-content { flex-direction:column; text-align:center; }
    nav ul { justify-content:center; margin:20px 0; flex-wrap:wrap; }
    nav ul li { margin:5px 10px; }
    .hero h1 { font-size:32px; }
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
            <li><a href="aboutus.jsp">About Us</a></li>
            <li><a href="contact.jsp">Contact</a></li>
            <li><a href="faq.jsp" class="active">FAQ</a></li>
        </ul>
    </nav>
    <div class="nav-buttons">
        <%
            if(username != null){
        %>
            <a href="profile.jsp" class="btn btn-outline"><i class="fas fa-user-circle"></i> <%= username %></a>
            <a href="logout.jsp" class="btn">Logout</a>
        <%
            } else {
        %>
            <a href="login.jsp" class="btn btn-outline">Login</a>
            <a href="register.jsp" class="btn">Register</a>
        <%
            }
        %>
    </div>
</div>
</header>

<!-- Hero -->
<div class="container">
    <div class="hero">
        <h1>Frequently Asked Questions</h1>
        <p>Find answers to common questions about our roommate matching service</p>
    </div>

    <!-- FAQ Section -->
    <div class="faq-container">
        <div class="input-group">
            <input type="text" id="faqSearch" placeholder="Search questions...">
            <button class="btn-search" type="button" id="searchButton"><i class="fas fa-search"></i></button>
        </div>

        <div class="accordion" id="faqAccordion">

            <!-- General Questions -->
            <h3 class="category-title">General Questions</h3>
            <div class="accordion-item">
                <h2 class="accordion-header" id="genOne">
                    <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#collapseGenOne">
                        What is RoommateFinder?
                    </button>
                </h2>
                <div id="collapseGenOne" class="accordion-collapse collapse show" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        RoommateFinder helps students find compatible roommates based on lifestyle, budget, and location preferences.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="genTwo">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseGenTwo">
                        Is RoommateFinder free to use?
                    </button>
                </h2>
                <div id="collapseGenTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Yes! RoommateFinder is completely free for university students.
                    </div>
                </div>
            </div>

            <!-- Account & Profile -->
            <h3 class="category-title">Account & Profile</h3>
            <div class="accordion-item">
                <h2 class="accordion-header" id="accOne">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAccOne">
                        How do I create an account?
                    </button>
                </h2>
                <div id="collapseAccOne" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Just click the <strong>Register</strong> button, fill in your details, and verify your university email.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="accTwo">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseAccTwo">
                        Can I update my roommate preferences later?
                    </button>
                </h2>
                <div id="collapseAccTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Yes. You can update your profile anytime to change budget, lifestyle, or other preferences.
                    </div>
                </div>
            </div>

            <!-- Matching & Search -->
            <h3 class="category-title">Matching & Search</h3>
            <div class="accordion-item">
                <h2 class="accordion-header" id="matchOne">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseMatchOne">
                        How does the roommate matching system work?
                    </button>
                </h2>
                <div id="collapseMatchOne" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        We use a compatibility algorithm to match you with potential roommates who share similar preferences.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="matchTwo">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseMatchTwo">
                        Can I search for roommates manually?
                    </button>
                </h2>
                <div id="collapseMatchTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Yes! You can browse profiles and filter by location, budget, or lifestyle.
                    </div>
                </div>
            </div>

            <!-- Safety & Privacy -->
            <h3 class="category-title">Safety & Privacy</h3>
            <div class="accordion-item">
                <h2 class="accordion-header" id="safeOne">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSafeOne">
                        How does RoommateFinder ensure safety?
                    </button>
                </h2>
                <div id="collapseSafeOne" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        We verify accounts with university emails, allow reports of suspicious users, and encourage safe meetups before moving in.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="safeTwo">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSafeTwo">
                        Is my personal information secure?
                    </button>
                </h2>
                <div id="collapseSafeTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Yes. Only the details you choose to share are visible to other users. Your private data is never shared.
                    </div>
                </div>
            </div>

            <!-- Support -->
            <h3 class="category-title">Support</h3>
            <div class="accordion-item">
                <h2 class="accordion-header" id="supOne">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSupOne">
                        How can I contact support?
                    </button>
                </h2>
                <div id="collapseSupOne" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        You can reach us through the <a href="contact.jsp">Contact Page</a> or email <strong>support@roommatefinder.com</strong>.
                    </div>
                </div>
            </div>
            <div class="accordion-item">
                <h2 class="accordion-header" id="supTwo">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapseSupTwo">
                        What if I can’t find a suitable roommate?
                    </button>
                </h2>
                <div id="collapseSupTwo" class="accordion-collapse collapse" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        Our user base is growing daily. Try adjusting filters and check back often for new matches.
                    </div>
                </div>
            </div>

        </div>

        <!-- Support Card -->
        <div class="support-card">
            <i class="fas fa-headset support-icon mb-3"></i>
            <h3>Still have questions?</h3>
            <p class="text-muted">Our support team is here to help you.</p>
            <a href="contact.jsp" class="btn mt-2">Contact Support</a>
        </div>
    </div>
</div>

<!-- Footer -->
<footer>
<div class="container">
    <div class="footer-content">
        <div class="footer-column">
            <h3>RoommateFinder</h3>
            <p>Helping university students find compatible roommates since 2023.</p>
            <div class="footer-social">
                <a href="#"><i class="fab fa-facebook-f"></i></a>
                <a href="#"><i class="fab fa-twitter"></i></a>
                <a href="#"><i class="fab fa-instagram"></i></a>
                <a href="#"><i class="fab fa-linkedin-in"></i></a>
            </div>
        </div>
        <div class="footer-column">
            <h3>Quick Links</h3>
            <ul>
                <li><a href="index.jsp">Home</a></li>
                <li><a href="aboutus.jsp">About Us</a></li>
                <li><a href="contact.jsp">Contact</a></li>
                <li><a href="faq.jsp">FAQ</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Resources</h3>
            <ul>
                <li><a href="#">Roommate Tips</a></li>
                <li><a href="#">University Housing</a></li>
                <li><a href="#">Safety Guidelines</a></li>
            </ul>
        </div>
        <div class="footer-column">
            <h3>Legal</h3>
            <ul>
                <li><a href="#">Terms of Service</a></li>
                <li><a href="#">Privacy Policy</a></li>
                <li><a href="#">Cookie Policy</a></li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">© <%= java.time.Year.now() %> RoommateFinder. All rights reserved.</div>
</div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
document.addEventListener('DOMContentLoaded', function() {
    const faqSearch = document.getElementById('faqSearch');
    const searchButton = document.getElementById('searchButton');

    function performSearch() {
        const searchTerm = faqSearch.value.toLowerCase();
        const items = document.querySelectorAll('.accordion-item');
        items.forEach(item => {
            const question = item.querySelector('.accordion-button').textContent.toLowerCase();
            const answer = item.querySelector('.accordion-body').textContent.toLowerCase();
            if(question.includes(searchTerm) || answer.includes(searchTerm)){
                item.style.display='block';
            } else {
                item.style.display='none';
            }
        });
    }

    searchButton.addEventListener('click', performSearch);
    faqSearch.addEventListener('keyup', function(e){ if(e.key==='Enter') performSearch(); });
});
</script>
</body>
</html>
