// Footer loader for standardizing footer across all pages
function loadFooter() {
    fetch('footer.html')
        .then(response => {
            if (!response.ok) {
                throw new Error('Failed to load footer');
            }
            return response.text();
        })
        .then(html => {
            const footerContainer = document.getElementById('footer-container');
            if (footerContainer) {
                footerContainer.innerHTML = html;
                
                // Update copyright year after footer is loaded
                const copyrightYear = document.getElementById('copyright-year');
                if (copyrightYear) {
                    copyrightYear.textContent = new Date().getFullYear();
                }
            }
        })
        .catch(error => {
            console.error('Error loading footer:', error);
        });
}

// Load footer when DOM is ready
document.addEventListener('DOMContentLoaded', loadFooter);
