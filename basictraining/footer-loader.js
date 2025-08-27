document.addEventListener('DOMContentLoaded', function() {
    fetch('./footer.html')
        .then(response => response.text())
        .then(data => {
            document.getElementById('footer-container').innerHTML = data;
        });
});
