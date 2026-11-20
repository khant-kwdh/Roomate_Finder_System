<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Multi-Step Survey</title>
<style>
:root{--primary:#1a73e8;--light:#f8f9fa;}
body{font-family:Arial,sans-serif;background:#f9fafb;padding:20px;display:flex;justify-content:center;}
form{background:white;padding:30px;border-radius:10px;box-shadow:0 8px 20px rgba(0,0,0,0.1);width:100%;max-width:700px;}
h2{color:var(--primary);text-align:center;margin-bottom:20px;}
h3{color:var(--primary);margin-top:20px;margin-bottom:10px;}
input[type="text"], input[type="number"], select{width:100%;padding:10px;margin-bottom:10px;border:1px solid #ccc;border-radius:6px;}
.radio-group{display:flex;gap:15px;margin-bottom:15px;}
.radio-group label{padding:8px 12px;background:#f0f0f0;border-radius:6px;cursor:pointer;}
button{padding:12px 25px;background:var(--primary);color:white;border:none;border-radius:6px;cursor:pointer;margin-top:10px;}
button:hover{background:#1557b7;}
.step{display:none;}
.step.active{display:block;}
.nav-buttons{display:flex;justify-content:space-between;}
</style>
</head>
<body>
<form id="surveyForm" action="saveSurvey.jsp" method="post">
    <h2>University Compatibility Survey</h2>

    <!-- Step 1: Personal Info -->
    <div class="step active">
        <h3>Personal Info</h3>
        Name: <input type="text" name="name" required>
        Gender:
        <div class="radio-group">
            <label><input type="radio" name="gender" value="male" required> Male</label>
            <label><input type="radio" name="gender" value="female"> Female</label>
            <label><input type="radio" name="gender" value="other"> Other</label>
        </div>
        Age: <input type="number" name="age" required>
        Major: <input type="text" name="major" placeholder="e.g., Computer Science" required>
        Year:
        <select name="year" required>
            <option>Freshman</option>
            <option>Sophomore</option>
            <option>Junior</option>
            <option>Senior</option>
            <option>Graduate</option>
        </select>
    </div>

    <!-- Step 2: Academic Preferences -->
    <div class="step">
        <h3>Academic Preferences</h3>
        Preferred Study Time:
        <select name="study_time" required>
            <option>Morning</option>
            <option>Night</option>
            <option>Flexible</option>
        </select>
        Study Environment:
        <select name="study_environment" required>
            <option>Library</option>
            <option>Dorm</option>
            <option>Cafe</option>
            <option>Home</option>
        </select>
        Learning Style:
        <select name="learning_style" required>
            <option>Visual</option>
            <option>Auditory</option>
            <option>Reading/Writing</option>
            <option>Hands-on</option>
        </select>
        Study Group Preference:
        <select name="study_group" required>
            <option>Alone</option>
            <option>Small group</option>
            <option>Large group</option>
        </select>
    </div>

    <!-- Step 3: Lifestyle & Personality -->
    <div class="step">
        <h3>Lifestyle & Personality</h3>
        Morning or Night Person:
        <div class="radio-group">
            <label><input type="radio" name="morning_or_night" value="Morning" required> Morning</label>
            <label><input type="radio" name="morning_or_night" value="Night"> Night</label>
        </div>
        Preferred Environment:
        <div class="radio-group">
            <label><input type="radio" name="quiet_or_noise" value="Quiet" required> Quiet</label>
            <label><input type="radio" name="quiet_or_noise" value="Background Noise"> Background Noise</label>
        </div>
        Introvert/Extrovert:
        <div class="radio-group">
            <label><input type="radio" name="intro_extro" value="Introvert" required> Introvert</label>
            <label><input type="radio" name="intro_extro" value="Extrovert"> Extrovert</label>
        </div>
        Interaction Style:
        <div class="radio-group">
            <label><input type="radio" name="group_or_oneonone" value="Group" required> Group</label>
            <label><input type="radio" name="group_or_oneonone" value="One-on-one"> One-on-one</label>
        </div>
    </div>

    <!-- Step 4: Goals & Interests -->
    <div class="step">
        <h3>Goals & Interests</h3>
        Academic Goal: <input type="text" name="academic_goal" placeholder="e.g., Graduate with Honors" required>
        Career Goal: <input type="text" name="career_goal" placeholder="e.g., Software Engineer at Google" required>
        Personal Goal: <input type="text" name="personal_goal" placeholder="e.g., Learn a new language" required>
        Motivation: <input type="text" name="motivation" placeholder="e.g., Improve skills and meet new people" required>
        Hobbies: <input type="text" name="hobbies" placeholder="e.g., Reading, Gaming">
        Favorite Movies: <input type="text" name="favorite_movies" placeholder="e.g., Inception, Avengers">
    </div>

    <div class="nav-buttons">
        <button type="button" id="prevBtn" onclick="nextPrev(-1)">Previous</button>
        <button type="button" id="nextBtn" onclick="nextPrev(1)">Next</button>
    </div>
</form>

<script>
let currentStep = 0;
showStep(currentStep);

function showStep(n) {
    const steps = document.getElementsByClassName("step");
    steps[n].classList.add("active");
    document.getElementById("prevBtn").style.display = n==0 ? "none":"inline-block";
    document.getElementById("nextBtn").innerHTML = n==steps.length-1?"Submit":"Next";
}

function nextPrev(n){
    const steps = document.getElementsByClassName("step");
    steps[currentStep].classList.remove("active");
    currentStep += n;
    if(currentStep >= steps.length){
        document.getElementById("surveyForm").submit();
        return false;
    }
    showStep(currentStep);
}
</script>
</body>
</html>
