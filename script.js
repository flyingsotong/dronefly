document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('requirementsForm');
    const resultsContent = document.getElementById('results-content');
    const mobileMenuButton = document.getElementById('mobile-menu-button');
    const mobileMenu = document.getElementById('mobile-menu');
    const mobileMenuLinks = document.querySelectorAll('.mobile-menu-link');
    mobileMenuButton.addEventListener('click', () => {
        mobileMenu.classList.toggle('hidden');
    });
    mobileMenuLinks.forEach(link => {
        link.addEventListener('click', () => {
            mobileMenu.classList.add('hidden');
        });
    });

    function updateRequirements() {
        const weight = form.querySelector('input[name="drone-weight"]:checked').value;
        const purpose = form.querySelector('input[name="drone-purpose"]:checked').value;
        const location = form.querySelector('input[name="flying-location"]:checked').value;
        let html = '<ul class="list-disc pl-5 space-y-1">';
        let requiresRemoteID = false;
        if (location === 'indoors') {
            html += '<li>For private indoor spaces, registration and pilot licenses are generally not required.</li>';
            html += '<li><strong>However</strong>, if flying in a <strong>publicly accessible indoor area</strong> (e.g., a mall, stadium) or for an event with <strong>more than 50 people</strong>, a <strong>UA Pilot Licence</strong> and <a href="https://www.caas.gov.sg/public-passengers/unmanned-aircraft/ua-regulatory-requirements/ua-operator-and-activity-permits" target="_blank" class="text-indigo-400 hover:underline">permits</a> are required.</li>';
        } else { // Outdoors
            if (purpose === 'commercial') {
                html += '<li>An <a href="https://www.caas.gov.sg/public-passengers/unmanned-aircraft/ua-regulatory-requirements/ua-operator-and-activity-permits" target="_blank" class="text-indigo-400 hover:underline"><strong>Operator Permit</strong> and <strong>Class 1 Activity Permit</strong></a> are required.</li>';
                html += '<li>A <a href="#faq-uapl" class="text-indigo-400 hover:underline"><strong>UA Pilot Licence (UAPL)</strong></a> is required for the pilot. This involves theory and practical tests.</li>';
                if (weight !== 'under_250g') {
                    html += '<li>Drone must be <a href="#faq-register" class="text-indigo-400 hover:underline"><strong>registered</strong></a>.</li>';
                    requiresRemoteID = true;
                }
            } else { // Recreational or Educational
                switch (weight) {
                    case 'under_250g':
                        html += '<li>No registration or license required for basic flying.</li>';
                        break;
                    case '250g_to_1.5kg':
                        html += '<li>Drone must be <a href="#faq-register" class="text-indigo-400 hover:underline"><strong>registered</strong></a>.</li>';
                        html += '<li>No pilot license is required for basic flying.</li>';
                        requiresRemoteID = true;
                        break;
                    case '1.5kg_to_7kg':
                        html += '<li>Drone must be <a href="#faq-register" class="text-indigo-400 hover:underline"><strong>registered</strong></a>.</li>';
                        html += '<li>A <a href="#faq-uabt" class="text-indigo-400 hover:underline"><strong>UA Basic Training (UABT)</strong></a> certificate is required. This involves a simple online theory course and test.</li>';
                        requiresRemoteID = true;
                        break;
                    case 'over_7kg':
                        html += '<li>Drone must be <a href="#faq-register" class="text-indigo-400 hover:underline"><strong>registered</strong></a>.</li>';
                        html += '<li>A full <a href="#faq-uapl" class="text-indigo-400 hover:underline"><strong>UA Pilot Licence (UAPL)</strong></a> is required. This involves theory and practical tests.</li>';
                        requiresRemoteID = true;
                        break;
                }
                html += '<li>A <a href="https://www.caas.gov.sg/public-passengers/unmanned-aircraft/ua-regulatory-requirements/ua-operator-and-activity-permits" target="_blank" class="text-indigo-400 hover:underline"><strong>Class 2 Activity Permit</strong></a> is required for flying above 200ft, within 5km of an aerodrome, or within other restricted areas.</li>';
                if (purpose === 'recreational') {
                    html += '<li>For more complex operations (e.g., flying a drone over 25kg or flying Beyond Visual Line-of-Sight), an <a href="https://www.caas.gov.sg/public-passengers/unmanned-aircraft/ua-regulatory-requirements/ua-operator-and-activity-permits" target="_blank" class="text-indigo-400 hover:underline"><strong>Operator Permit</strong> and <strong>Class 1 Activity Permit</strong></a> are required.</li>';
                } else { // Educational
                    html += '<li>For more complex operations (e.g., flying a drone over 7kg or flying Beyond Visual Line-of-Sight), an <a href="https://www.caas.gov.sg/public-passengers/unmanned-aircraft/ua-regulatory-requirements/ua-operator-and-activity-permits" target="_blank" class="text-indigo-400 hover:underline"><strong>Operator Permit</strong> and <strong>Class 1 Activity Permit</strong></a> are required.</li>';
                }
            }
            if (requiresRemoteID) {
                html += '<li><strong>Upcoming:</strong> From <strong>1 Dec 2025</strong>, your drone must have <a href="#faq-remote-id" class="text-indigo-400 hover:underline"><strong>Broadcast Remote ID (B-RID)</strong></a>.</li>';
            }
        }
        html += '</ul>';
        resultsContent.innerHTML = html;
    }
    form.addEventListener('change', updateRequirements);
    updateRequirements();
    const faqQuestions = document.querySelectorAll('.faq-question');
    faqQuestions.forEach(button => {
        button.addEventListener('click', () => {
            const answer = button.nextElementSibling;
            const icon = button.querySelector('span:last-child');
            const isExpanded = button.getAttribute('aria-expanded') === 'true';

            button.setAttribute('aria-expanded', !isExpanded);
            answer.style.display = isExpanded ? 'none' : 'block';
            icon.style.transform = isExpanded ? 'rotate(0deg)' : 'rotate(45deg)';
        });
    });

    const expandAllButton = document.getElementById('expand-all-faq');
    if (expandAllButton) {
        expandAllButton.addEventListener('click', () => {
            const allQuestions = document.querySelectorAll('.faq-question');
            const isCollapsing = expandAllButton.textContent === 'Collapse all';

            allQuestions.forEach(button => {
                const answer = button.nextElementSibling;
                const icon = button.querySelector('span:last-child');

                button.setAttribute('aria-expanded', isCollapsing ? 'false' : 'true');
                answer.style.display = isCollapsing ? 'none' : 'block';
                icon.style.transform = isCollapsing ? 'rotate(0deg)' : 'rotate(45deg)';
            });

            expandAllButton.textContent = isCollapsing ? 'Expand all' : 'Collapse all';
        });
    }
    // Accessible Tooltips on Click            
    const tooltipTriggers = document.querySelectorAll('.group .cursor-pointer');
    tooltipTriggers.forEach(trigger => {
        trigger.addEventListener('click', () => {
            const tooltip = trigger.nextElementSibling;
            if (tooltip && tooltip.classList.contains('absolute')) {
                // Simple toggle logic                        
                const isVisible = tooltip.classList.contains('opacity-100');
                // Hide all other tooltips first                        
                document.querySelectorAll('.group .absolute').forEach(t => t.classList.remove('opacity-100'));
                // Show the clicked one if it was hidden                        
                if (!isVisible) {
                    tooltip.classList.add('opacity-100');
                }
            }
        });
    });

    // Back to Top Button
    const backToTopButton = document.getElementById('back-to-top-button');
    if (backToTopButton) {
        window.addEventListener('scroll', () => {
            if (window.pageYOffset > 300) { // Show button after scrolling 300px
                backToTopButton.classList.remove('hidden');
            } else {
                backToTopButton.classList.add('hidden');
            }
        });

        backToTopButton.addEventListener('click', (e) => {
            e.preventDefault();
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    }
});
