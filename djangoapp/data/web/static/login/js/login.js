function func() {
    var email = document.getElementById("username").value;
    var pass = document.getElementById('password').value;
    if (email == 'eduarda.nask@gmail.com' && pass == 'T0m4t3123'){
        window.location.assign("cadastrar.html");
    }
    else{
        alert("Permission danied.")
    }
}