<%@ page contentType="text/html;charset=UTF-8" session="true" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register - RoommateFinder</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .form-container {
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            width: 100%;
            max-width: 500px;
        }
        h2 { text-align: center; color: #0275d8; margin-bottom: 20px; }
        label { display: block; margin-top: 15px; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="email"], input[type="password"], input[type="number"], select {
            width: 100%;
            padding: 10px;
            border-radius: 5px;
            border: 1px solid #ccc;
            box-sizing: border-box;
        }
        button {
            margin-top: 20px;
            width: 100%;
            padding: 10px;
            background-color: #0275d8;
            border: none;
            border-radius: 5px;
            color: white;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover { background-color: #025aa5; }
        .error { color: #e74c3c; text-align: center; margin-bottom: 10px; }
        .success { color: #27ae60; text-align: center; margin-bottom: 10px; }
        .form-step { display: none; }
        .form-step.active { display: block; }
        .form-navigation { display: flex; justify-content: space-between; margin-top: 20px; }
        .checkbox-group { margin-top: 10px; }
    </style>
</head>
<body>

<div class="form-container">
    <h2>Create Your Account</h2>

    <% String error = (String) request.getAttribute("error"); %>
    <% String message = (String) request.getAttribute("message"); %>
    <% if (error != null) { %>
        <p class="error"><%= error %></p>
    <% } %>
    <% if (message != null) { %>
        <p class="success"><%= message %></p>
    <% } %>

    <form id="signupForm" action="register" method="post">

        <!-- Step 1: Email & Password -->
        <div class="form-step active" data-step="1">
            <label>Email Address</label>
            <input type="email" name="email" required>

            <label>Password</label>
            <input type="password" name="password" id="password" required>

            <label>Confirm Password</label>
            <input type="password" name="confirm_password" id="confirm_password" required>

            <div class="form-navigation">
                <div></div>
                <button type="button" class="next-step">Next</button>
            </div>
        </div>

        <!-- Step 2: User Info -->
        <div class="form-step" data-step="2">
            <label>Username</label>
            <input type="text" name="username" required>

            <label>Age</label>
            <input type="number" name="age" min="18" max="99" required>

            <label>Gender</label>
            <select name="gender" required>
                <option value="">Select your gender</option>
                <option value="male">Male</option>
                <option value="female">Female</option>
                <option value="non-binary">Non-binary</option>
                <option value="other">Other</option>
                <option value="prefer-not-to-say">Prefer not to say</option>
            </select>

            <label>Occupation</label>
            <input type="text" name="occupation" required>

            <div class="form-navigation">
                <button type="button" class="prev-step">Previous</button>
                <button type="button" class="next-step">Next</button>
            </div>
        </div>

        <!-- Step 3: Optional Info & Preferences -->
        <div class="form-step" data-step="3">
            <label>Preferred Location</label>
            <input type="text" name="location">

            <label>Monthly Budget ($)</label>
            <input type="number" name="budget" min="0">

            <label>Lifestyle Preferences</label>
            <div class="checkbox-group">
                <input type="checkbox" name="preferences" value="non-smoker"> Non-smoker
            </div>
            <div class="checkbox-group">
                <input type="checkbox" name="preferences" value="pet-friendly"> Pet friendly
            </div>
            <div class="checkbox-group">
                <input type="checkbox" name="preferences" value="clean"> Prefers clean living space
            </div>
            <div class="checkbox-group">
                <input type="checkbox" name="preferences" value="quiet"> Prefers quiet environment
            </div>
            <div class="checkbox-group">
                <input type="checkbox" name="preferences" value="social"> Enjoys social activities
            </div>

            <div class="checkbox-group">
                <input type="checkbox" name="terms" required> I agree to the <a href="#">Terms of Service</a> and <a href="#">Privacy Policy</a>
            </div>

            <div class="form-navigation">
                <button type="button" class="prev-step">Previous</button>
                <button type="submit">Create Account</button>
            </div>
        </div>

    </form>

    <p style="text-align:center; margin-top: 20px;">
        Already have an account? <a href="login.jsp">Login here</a>.
    </p>
</div>

<script>
    const nextBtns = document.querySelectorAll('.next-step');
    const prevBtns = document.querySelectorAll('.prev-step');
    const steps = document.querySelectorAll('.form-step');

    let currentStep = 0;

    nextBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            steps[currentStep].classList.remove('active');
            currentStep = Math.min(steps.length - 1, currentStep + 1);
            steps[currentStep].classList.add('active');
        });
    });

    prevBtns.forEach(btn => {
        btn.addEventListener('click', () => {
            steps[currentStep].classList.remove('active');
            currentStep = Math.max(0, currentStep - 1);
            steps[currentStep].classList.add('active');
        });
    });

    // Password confirmation check
    const form = document.getElementById('signupForm');
    form.addEventListener('submit', function(e) {
        const password = document.getElementById('password').value;
        const confirm = document.getElementById('confirm_password').value;
        if (password !== confirm) {
            e.preventDefault();
            alert("Passwords do not match!");
        }
    });
</script>

</body>
</html>
