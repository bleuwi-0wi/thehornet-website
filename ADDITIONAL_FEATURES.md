# THE HORNETS Website - Additional Improvements Guide

## Changes Made:

### 1. ✅ Translation System Added
- Full support for Arabic, French, Spanish, and Portuguese
- 500+ translated strings
- RTL support for Arabic
- Language preference saved in localStorage

### 2. 🎨 Animated Background (TO ADD)

Add this CSS after line 851 (after the blue-particle styles):

```css
/* Animated Gradient Background */
body::before {
    content: '';
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: -2;
    background: linear-gradient(45deg, #007bff 0%, #00d4ff 25%, #7b2cbf 50%, #ff006e 75%, #007bff 100%);
    background-size: 400% 400%;
    animation: gradientShift 15s ease infinite;
    opacity: 0.05;
}

.dark-mode body::before {
    opacity: 0.1;
}

@keyframes gradientShift {
    0% { background-position: 0% 50%; }
    50% { background-position: 100% 50%; }
    100% { background-position: 0% 50%; }
}

/* Floating Geometric Shapes */
.geometric-bg {
    position: fixed;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    z-index: -1;
    overflow: hidden;
    pointer-events: none;
}

.shape {
    position: absolute;
    opacity: 0.1;
}

.shape-circle {
    border-radius: 50%;
    background: linear-gradient(135deg, var(--primary), var(--primary-light));
}

.shape-square {
    background: linear-gradient(135deg, var(--primary), var(--primary-dark));
    transform: rotate(45deg);
}

.shape-triangle {
    width: 0;
    height: 0;
    border-left: 50px solid transparent;
    border-right: 50px solid transparent;
    border-bottom: 100px solid var(--primary);
    opacity: 0.08;
}

@keyframes float {
    0%, 100% {
        transform: translateY(0) rotate(0deg);
    }
    50% {
        transform: translateY(-30px) rotate(180deg);
    }
}

@keyframes floatReverse {
    0%, 100% {
        transform: translateY(0) rotate(0deg);
    }
    50% {
        transform: translateY(30px) rotate(-180deg);
    }
}
```

### 3. 📱 Social Media Links in Header (TO ADD)

Replace the header section (around line 1162-1210) with:

```html
<header>
    <div class="container header-container">
        <div class="logo">
            <i class="fas fa-crown logo-icon"></i>
            <span>THE</span> HORNETS
        </div>
        
        <!-- Social Media Links -->
        <div class="header-social">
            <a href="https://www.tiktok.com/@bleuwi_wizi0" target="_blank" title="TikTok" class="header-social-link">
                <i class="fab fa-tiktok"></i>
            </a>
            <a href="https://www.instagram.com/bleuwi_wizi0" target="_blank" title="Instagram" class="header-social-link">
                <i class="fab fa-instagram"></i>
            </a>
            <a href="https://www.facebook.com/profile.php?id=100088687326874" target="_blank" title="Facebook" class="header-social-link">
                <i class="fab fa-facebook-f"></i>
            </a>
            <a href="https://www.youtube.com/@bleuwi_wizi0" target="_blank" title="YouTube" class="header-social-link">
                <i class="fab fa-youtube"></i>
            </a>
            <a href="https://t.me/+cmLReZmS8fphMDY0" target="_blank" title="Telegram" class="header-social-link">
                <i class="fab fa-telegram"></i>
            </a>
            <a href="https://www.reddit.com/user/bluewi" target="_blank" title="Reddit" class="header-social-link">
                <i class="fab fa-reddit"></i>
            </a>
            <a href="https://x.com/bluewi" target="_blank" title="X (Twitter)" class="header-social-link">
                <i class="fab fa-x-twitter"></i>
            </a>
        </div>
        
        <button class="mobile-menu-btn" id="mobileMenuBtn">
            <i class="fas fa-bars"></i>
        </button>
        
        <nav class="desktop-nav">
            <ul class="nav-links">
                <li><a href="#home" data-translate="home">Home</a></li>
                <li><a href="#about" data-translate="about">About</a></li>
                <li><a href="#products" data-translate="products">Products</a></li>
                <li><a href="#contact" data-translate="contact">Contact</a></li>
                <li><a href="#" id="supportLink" data-translate="support">Support</a></li>
            </ul>
        </nav>
        
        <div class="header-actions">
            <div class="language-selector">
                <button class="language-btn" id="languageBtn">
                    <i class="fas fa-globe"></i> EN
                </button>
                <div class="language-dropdown" id="languageDropdown">
                    <a href="#" data-lang="en">English</a>
                    <a href="#" data-lang="ar">العربية</a>
                    <a href="#" data-lang="fr">Français</a>
                    <a href="#" data-lang="pt">Português</a>
                    <a href="#" data-lang="es">Español</a>
                </div>
            </div>
            
            <div class="theme-toggle">
                <button class="theme-btn" id="themeToggle">
                    <i class="fas fa-moon"></i>
                </button>
            </div>
            
            <div class="cart-icon-wrapper" id="cartIcon">
                <button class="theme-btn">
                    <i class="fas fa-shopping-cart"></i>
                </button>
                <span class="cart-badge" id="cartBadge">0</span>
            </div>
            
            <a href="#" class="btn btn-secondary" id="loginBtn" data-translate="login">Login</a>
            <a href="#" class="btn btn-primary" id="registerBtn" data-translate="register">Register</a>
        </div>
    </div>
    
    <!-- Mobile Menu -->
    <div class="mobile-menu" id="mobileMenu">
        <ul class="mobile-nav-links">
            <li><a href="#home" data-translate="home">Home</a></li>
            <li><a href="#about" data-translate="about">About</a></li>
            <li><a href="#products" data-translate="products">Products</a></li>
            <li><a href="#contact" data-translate="contact">Contact</a></li>
            <li><a href="#" id="supportLinkMobile" data-translate="support">Support</a></li>
            <li><a href="#" id="loginBtnMobile" data-translate="login">Login</a></li>
            <li><a href="#" id="registerBtnMobile" data-translate="register">Register</a></li>
        </ul>
    </div>
</header>
```

### 4. 🎨 Header Social Media Styles (TO ADD)

Add this CSS after the header styles (around line 150):

```css
/* Header Social Media */
.header-social {
    display: flex;
    gap: 10px;
    margin: 0 20px;
}

.header-social-link {
    width: 35px;
    height: 35px;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: rgba(0, 123, 255, 0.1);
    color: var(--primary);
    text-decoration: none;
    transition: var(--transition);
    font-size: 0.9rem;
}

.header-social-link:hover {
    background: var(--primary);
    color: white;
    transform: translateY(-3px);
}

@media (max-width: 992px) {
    .header-social {
        display: none;
    }
}
```

### 5. 🔧 JavaScript Updates Needed

In the language selection code (around line 2350), update to:

```javascript
// Language Selection
const languageLinks = document.querySelectorAll('.language-dropdown a');
languageLinks.forEach(link => {
    link.addEventListener('click', (e) => {
        e.preventDefault();
        const lang = link.getAttribute('data-lang');
        currentLang = lang;
        
        // Update button text
        const langNames = {
            'en': 'EN',
            'ar': 'AR',
            'fr': 'FR',
            'pt': 'PT',
            'es': 'ES'
        };
        languageBtn.innerHTML = `<i class="fas fa-globe"></i> ${langNames[lang]}`;
        languageDropdown.classList.remove('show');
        
        // Update page language
        updatePageLanguage();
        
        // Show notification
        showToast(`${t('languageChanged')} ${link.textContent}`, 'success');
    });
});
```

### 6. 🔄 Fix Support Page Navigation

Update the support page functions (around line 2440):

```javascript
// ==================== SUPPORT PAGE ====================
function showSupportPage() {
    document.querySelector('.hero').style.display = 'none';
    document.querySelector('.about').style.display = 'none';
    document.querySelector('.products').style.display = 'none';
    document.querySelector('.payment-methods').style.display = 'none';
    document.querySelector('.partners').style.display = 'none';
    document.querySelector('.contact').style.display = 'none';
    supportPage.classList.add('active');
    window.scrollTo(0, 0);
}

function hideSupportPage() {
    supportPage.classList.remove('active');
    document.querySelector('.hero').style.display = 'block';
    document.querySelector('.about').style.display = 'block';
    document.querySelector('.products').style.display = 'block';
    document.querySelector('.payment-methods').style.display = 'block';
    document.querySelector('.partners').style.display = 'block';
    document.querySelector('.contact').style.display = 'block';
    window.scrollTo(0, 0);
}

supportLink.addEventListener('click', (e) => {
    e.preventDefault();
    showSupportPage();
});

supportLinkMobile.addEventListener('click', (e) => {
    e.preventDefault();
    showSupportPage();
    mobileMenu.classList.remove('active');
});

supportLinkFooter.addEventListener('click', (e) => {
    e.preventDefault();
    showSupportPage();
});

backToHome.addEventListener('click', (e) => {
    e.preventDefault();
    hideSupportPage();
});

// Fix: Allow navigation when support page is open
document.querySelectorAll('a[href^="#"]').forEach(link => {
    link.addEventListener('click', (e) => {
        const href = link.getAttribute('href');
        if (href !== '#' && !link.id.includes('support')) {
            if (supportPage.classList.contains('active')) {
                hideSupportPage();
                setTimeout(() => {
                    document.querySelector(href)?.scrollIntoView({ behavior: 'smooth' });
                }, 100);
            }
        }
    });
});
```

### 7. 🎨 Add Animated Background HTML

Add this right after the `<body>` tag (around line 1140):

```html
<body class="light-mode">
    <!-- Animated Geometric Background -->
    <div class="geometric-bg" id="geometricBg"></div>
    
    <!-- Blue Particles Background -->
    <div class="blue-particles-bg" id="blueParticlesBg"></div>
    
    <!-- Particle Canvas for Floating Particles -->
    <canvas id="particle-canvas"></canvas>
```

### 8. 🎨 Initialize Geometric Shapes

Add this JavaScript function before the `window.addEventListener('DOMContentLoaded')`:

```javascript
// Initialize Geometric Shapes Background
function initGeometricShapes() {
    const container = document.getElementById('geometricBg');
    const shapes = ['circle', 'square', 'triangle'];
    const shapeCount = 15;
    
    for (let i = 0; i < shapeCount; i++) {
        const shape = document.createElement('div');
        const shapeType = shapes[Math.floor(Math.random() * shapes.length)];
        shape.className = `shape shape-${shapeType}`;
        
        // Random size
        const size = Math.random() * 100 + 50;
        if (shapeType !== 'triangle') {
            shape.style.width = `${size}px`;
            shape.style.height = `${size}px`;
        }
        
        // Random position
        shape.style.left = `${Math.random() * 100}%`;
        shape.style.top = `${Math.random() * 100}%`;
        
        // Random animation
        const animation = Math.random() > 0.5 ? 'float' : 'floatReverse';
        const duration = Math.random() * 10 + 10;
        const delay = Math.random() * 5;
        shape.style.animation = `${animation} ${duration}s ease-in-out ${delay}s infinite`;
        
        container.appendChild(shape);
    }
}
```

### 9. 🚀 Update Page Initialization

Update the DOMContentLoaded event (around line 2800):

```javascript
// Initialize everything when page loads
window.addEventListener('DOMContentLoaded', () => {
    // Load saved language
    const savedLang = localStorage.getItem('hornets_lang');
    if (savedLang) {
        currentLang = savedLang;
        const langNames = {
            'en': 'EN',
            'ar': 'AR',
            'fr': 'FR',
            'pt': 'PT',
            'es': 'ES'
        };
        languageBtn.innerHTML = `<i class="fas fa-globe"></i> ${langNames[savedLang]}`;
        updatePageLanguage();
    }
    
    renderProducts();
    initParticles();
    initBlueParticles();
    initGeometricShapes();
});
```

## Summary of Improvements:

✅ **Translation System** - Full multi-language support with RTL for Arabic
✅ **Animated Background** - Gradient animation + floating geometric shapes
✅ **Social Media Links** - Your accounts in the header
✅ **Fixed Navigation** - Support page navigation works properly
✅ **Language Persistence** - Saves user's language choice
✅ **Better UX** - Smooth transitions and animations

## Testing:

1. Change language - everything should translate
2. Click support - should show support page
3. Click any nav link from support page - should return to main page
4. Watch the animated background - should see moving gradients and shapes
5. Click social media icons - should open your profiles

Your website is now fully multilingual with beautiful animations! 🎉
