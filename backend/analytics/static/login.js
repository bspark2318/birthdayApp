// Sourced from https://medium.com/swlh/how-to-create-your-first-login-page-with-html-css-and-javascript-602dd71144f1

const loginForm = document.getElementById("login-form");
    const loginButton = document.getElementById("login-form-submit");
    const loginErrorMsg = document.getElementById("login-error-msg");
    
    loginButton.addEventListener("click", (e) => {
        e.preventDefault();
        const username = loginForm.username.value;
        const password = loginForm.password.value;
    
        if (username === "admin" && password === "mpcs52555") {
            alert("You have successfully logged in.");
            const table = document.getElementById("table_content");
            const login_content = document.getElementById("main-holder");
            login_content.style.display = "none"
            table.style.display = "block"
        } else {
            loginErrorMsg.style.opacity = 1;
        }
})