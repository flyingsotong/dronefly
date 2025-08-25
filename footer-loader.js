// Footer loader for standardizing footer across all pages
function loadFooter() {
    console.log('Loading footer...');
    
    // Determine the correct path based on current location
    const footerPath = window.location.pathname.includes('/basictraining/') ? '../footer.html' : 'footer.html';
    console.log('Footer path:', footerPath);
    
    const footerContainer = document.getElementById('footer-container');
    console.log('Footer container found:', !!footerContainer);
    
    if (!footerContainer) {
        console.error('Footer container not found!');
        return;
    }
    
    return fetch(footerPath, {mode: 'cors'})
        .then(response => {
            console.log('Fetch response status:', response.status);
            if (!response.ok) {
                throw new Error(`Failed to load footer: ${response.status}`);
            }
            return response.text();
        })
        .then(html => {
            console.log('Footer HTML loaded, length:', html.length);
            
            // Fix image paths for basictraining subdirectory
            if (window.location.pathname.includes('/basictraining/')) {
                html = html.replace(/src="images\//g, 'src="../images/');
            }
            
            footerContainer.innerHTML = html;
            console.log('Footer HTML inserted');
            console.log('Footer content:', footerContainer.innerHTML);
            
            // Update copyright year after footer is loaded
            const copyrightYear = document.getElementById('copyright-year');
            console.log('Copyright year element found:', !!copyrightYear);
            if (copyrightYear) {
                copyrightYear.textContent = new Date().getFullYear();
                console.log('Copyright year updated to:', new Date().getFullYear());
            } else {
                console.warn('Copyright year element not found in footer');
            }
            
            // Dispatch a custom event to signal that footer is loaded
            window.dispatchEvent(new CustomEvent('footerLoaded'));
            
            return true;
        })
        .catch(error => {
            console.error('Error loading footer:', error);
            console.error('Error stack:', error.stack);
        });
}

// Load footer when DOM is ready
document.addEventListener('DOMContentLoaded', loadFooter);
