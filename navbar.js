// ==========================================================================
// CONCEPT EXIM - Unified Global Navbar, Dropdown & Multilingual Controller
// ==========================================================================

(function() {
  'use strict';

  // 10 Supported International Trade Languages
  const SUPPORTED_LANGUAGES = [
    { code: 'en', name: 'English', native: 'English', flag: '🇬🇧', region: 'Global Trade (Default)', dir: 'ltr' },
    { code: 'ar', name: 'Arabic', native: 'العربية', flag: '🇸🇦', region: 'Middle East & GCC', dir: 'rtl' },
    { code: 'es', name: 'Spanish', native: 'Español', flag: '🇪🇸', region: 'Latin America & Spain', dir: 'ltr' },
    { code: 'fr', name: 'French', native: 'Français', flag: '🇫🇷', region: 'Europe & Africa', dir: 'ltr' },
    { code: 'de', name: 'German', native: 'Deutsch', flag: '🇩🇪', region: 'Central Europe', dir: 'ltr' },
    { code: 'zh', name: 'Chinese', native: '中文 (简体)', flag: '🇨🇳', region: 'Asia-Pacific & China', dir: 'ltr' },
    { code: 'hi', name: 'Hindi', native: 'हिन्दी', flag: '🇮🇳', region: 'India & South Asia', dir: 'ltr' },
    { code: 'ru', name: 'Russian', native: 'Русский', flag: '🇷🇺', region: 'Eurasia & CIS', dir: 'ltr' },
    { code: 'ja', name: 'Japanese', native: '日本語', flag: '🇯🇵', region: 'East Asia', dir: 'ltr' },
    { code: 'pt', name: 'Portuguese', native: 'Português', flag: '🇧🇷', region: 'South America & Europe', dir: 'ltr' }
  ];

  // High-Resolution Trade Dictionary for Instant UI Localization
  const TRANSLATIONS = {
    en: {
      globalReach: 'Global Reach',
      trustedSuppliers: 'Trusted Suppliers',
      qualityAssured: 'Quality Assured',
      onTimeDelivery: 'On-Time Delivery',
      loginRegister: 'Login / Register',
      trackCargo: 'Track Cargo',
      home: 'Home',
      about: 'About Us',
      products: 'Products',
      services: 'Services',
      network: 'Global Presence',
      compliance: 'Quality & Compliance',
      insights: 'Insights',
      contact: 'Contact',
      searchPlaceholder: 'Search commodities, trade services...',
      requestQuote: 'Request a Quote'
    },
    ar: {
      globalReach: 'وصول عالمي',
      trustedSuppliers: 'موردون موثوقون',
      qualityAssured: 'جودة مضمونة',
      onTimeDelivery: 'تسليم في الموعد',
      loginRegister: 'تسجيل الدخول / حساب جديد',
      trackCargo: 'تتبع الشحنة',
      home: 'الرئيسية',
      about: 'من نحن',
      products: 'المنتجات',
      services: 'خدماتنا',
      network: 'التواجد العالمي',
      compliance: 'الجودة والامتثال',
      insights: 'تقارير التجارة',
      contact: 'اتصل بنا',
      searchPlaceholder: 'البحث في السلع والخدمات التجارية...',
      requestQuote: 'طلب عرض أسعار'
    },
    es: {
      globalReach: 'Alcance Global',
      trustedSuppliers: 'Proveedores Confiables',
      qualityAssured: 'Calidad Garantizada',
      onTimeDelivery: 'Entrega a Tiempo',
      loginRegister: 'Iniciar Sesión / Registro',
      trackCargo: 'Rastrear Carga',
      home: 'Inicio',
      about: 'Quiénes Somos',
      products: 'Productos',
      services: 'Servicios',
      network: 'Presencia Global',
      compliance: 'Calidad y Cumplimiento',
      insights: 'Perspectivas',
      contact: 'Contacto',
      searchPlaceholder: 'Buscar productos, servicios comerciales...',
      requestQuote: 'Solicitar Cotización'
    },
    fr: {
      globalReach: 'Portée Mondiale',
      trustedSuppliers: 'Fournisseurs Agréés',
      qualityAssured: 'Qualité Garantie',
      onTimeDelivery: 'Livraison Ponctuelle',
      loginRegister: 'Connexion / Inscription',
      trackCargo: 'Suivre le Fret',
      home: 'Accueil',
      about: 'À Propos',
      products: 'Produits',
      services: 'Services',
      network: 'Présence Mondiale',
      compliance: 'Qualité & Conformité',
      insights: 'Analyses',
      contact: 'Contact',
      searchPlaceholder: 'Rechercher des marchandises et services...',
      requestQuote: 'Demander un Devis'
    },
    de: {
      globalReach: 'Globale Reichweite',
      trustedSuppliers: 'Geprüfte Lieferanten',
      qualityAssured: 'Garantierte Qualität',
      onTimeDelivery: 'Pünktliche Lieferung',
      loginRegister: 'Anmelden / Registrieren',
      trackCargo: 'Fracht Verfolgen',
      home: 'Startseite',
      about: 'Über Uns',
      products: 'Produkte',
      services: 'Dienstleistungen',
      network: 'Globale Präsenz',
      compliance: 'Qualität & Compliance',
      insights: 'Marktanalysen',
      contact: 'Kontakt',
      searchPlaceholder: 'Rohstoffe, Dienstleistungen suchen...',
      requestQuote: 'Angebot Anfordern'
    },
    zh: {
      globalReach: '通达全球',
      trustedSuppliers: '诚信供应商',
      qualityAssured: '卓越品质',
      onTimeDelivery: '准时交付',
      loginRegister: '登录 / 注册',
      trackCargo: '货物追踪',
      home: '首页',
      about: '关于我们',
      products: '出口商品',
      services: '贸易服务',
      network: '全球网络',
      compliance: '质量与合规',
      insights: '贸易洞察',
      contact: '联系我们',
      searchPlaceholder: '搜索商品、贸易服务...',
      requestQuote: '获取报价'
    },
    hi: {
      globalReach: 'वैश्विक पहुंच',
      trustedSuppliers: 'विश्वसनीय आपूर्तिकर्ता',
      qualityAssured: 'गुणवत्ता आश्वासन',
      onTimeDelivery: 'समय पर डिलीवरी',
      loginRegister: 'लॉगिन / रजिस्टर',
      trackCargo: 'कार्गो ट्रैक करें',
      home: 'होम',
      about: 'हमारे बारे में',
      products: 'उत्पाद',
      services: 'व्यापार सेवाएं',
      network: 'वैश्विक नेटवर्क',
      compliance: 'गुणवत्ता और मानक',
      insights: 'व्यापार अंतर्दृष्टि',
      contact: 'संपर्क करें',
      searchPlaceholder: 'जिंस और सेवाएं खोजें...',
      requestQuote: 'कोटेशन अनुरोध'
    },
    ru: {
      globalReach: 'Мировой Охват',
      trustedSuppliers: 'Надёжные Поставщики',
      qualityAssured: 'Гарантия Качества',
      onTimeDelivery: 'Доставка в Срок',
      loginRegister: 'Войти / Регистрация',
      trackCargo: 'Отследить Груз',
      home: 'Главная',
      about: 'О Компании',
      products: 'Продукция',
      services: 'Услуги',
      network: 'Международная Сеть',
      compliance: 'Стандарты Качества',
      insights: 'Аналитика Рынка',
      contact: 'Контакты',
      searchPlaceholder: 'Поиск товаров и услуг...',
      requestQuote: 'Запросить КП'
    },
    ja: {
      globalReach: 'グローバル展開',
      trustedSuppliers: '信頼のサプライヤー',
      qualityAssured: '確かな品質',
      onTimeDelivery: '納期厳守',
      loginRegister: 'ログイン / 登録',
      trackCargo: '貨物追跡',
      home: 'ホーム',
      about: '会社概要',
      products: '取扱商品',
      services: '貿易サービス',
      network: 'グローバル拠点',
      compliance: '品質管理・認証',
      insights: '市場インサイト',
      contact: 'お問い合わせ',
      searchPlaceholder: '商品・サービスを検索...',
      requestQuote: '見積り依頼'
    },
    pt: {
      globalReach: 'Alcance Global',
      trustedSuppliers: 'Fornecedores Confiáveis',
      qualityAssured: 'Qualidade Assegurada',
      onTimeDelivery: 'Entrega Pontual',
      loginRegister: 'Entrar / Registrar',
      trackCargo: 'Rastrear Carga',
      home: 'Início',
      about: 'Sobre Nós',
      products: 'Produtos',
      services: 'Serviços',
      network: 'Presença Global',
      compliance: 'Qualidade e Conformidade',
      insights: 'Informações',
      contact: 'Contato',
      searchPlaceholder: 'Buscar mercadorias e serviços...',
      requestQuote: 'Solicitar Cotação'
    }
  };

  // ==========================================================================
  // 1. NAVBAR DROPDOWNS CONTROLLER
  // ==========================================================================
  function initNavbarDropdowns() {
    const dropdownItems = document.querySelectorAll('.nav-item-dropdown');

    dropdownItems.forEach(item => {
      const arrowBtn = item.querySelector('.nav-arrow-btn');
      const navLink = item.querySelector('.nav-link');

      if (!arrowBtn && !navLink) return;

      // Click on Down Arrow Button
      if (arrowBtn) {
        arrowBtn.addEventListener('click', (e) => {
          e.preventDefault();
          e.stopPropagation();

          const isCurrentlyOpen = item.classList.contains('is-open');

          dropdownItems.forEach(otherItem => {
            if (otherItem !== item) {
              otherItem.classList.remove('is-open');
              const otherArrow = otherItem.querySelector('.nav-arrow-btn');
              if (otherArrow) otherArrow.setAttribute('aria-expanded', 'false');
            }
          });

          if (isCurrentlyOpen) {
            item.classList.remove('is-open');
            arrowBtn.setAttribute('aria-expanded', 'false');
          } else {
            item.classList.add('is-open');
            arrowBtn.setAttribute('aria-expanded', 'true');
          }
        });

        arrowBtn.addEventListener('keydown', (e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            e.preventDefault();
            e.stopPropagation();
            arrowBtn.click();
          }
        });
      }

      // Click on Nav Link Text
      if (navLink) {
        navLink.addEventListener('click', (e) => {
          if (e.target.closest('.nav-arrow-btn')) return;

          const href = navLink.getAttribute('href') || '';
          const currentPath = window.location.pathname;
          const isSamePage = currentPath.endsWith(href) || 
                             (href === 'index.html' && (currentPath.endsWith('/') || currentPath === ''));

          if (window.innerWidth <= 980 || isSamePage) {
            e.preventDefault();
            const isCurrentlyOpen = item.classList.contains('is-open');
            
            dropdownItems.forEach(otherItem => {
              if (otherItem !== item) {
                otherItem.classList.remove('is-open');
                const otherArrow = otherItem.querySelector('.nav-arrow-btn');
                if (otherArrow) otherArrow.setAttribute('aria-expanded', 'false');
              }
            });

            if (isCurrentlyOpen) {
              item.classList.remove('is-open');
              if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'false');
            } else {
              item.classList.add('is-open');
              if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'true');
            }
          }
        });
      }

      // Desktop Hover
      item.addEventListener('mouseenter', () => {
        if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'true');
      });

      item.addEventListener('mouseleave', () => {
        if (!item.classList.contains('is-open')) {
          if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'false');
        }
      });

      // Accessibility focus
      item.addEventListener('focusin', () => {
        item.classList.add('is-open');
        if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'true');
      });

      item.addEventListener('focusout', (e) => {
        if (!item.contains(e.relatedTarget)) {
          item.classList.remove('is-open');
          if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'false');
        }
      });
    });

    // Close on outside click
    document.addEventListener('click', (e) => {
      if (!e.target.closest('.nav-item-dropdown')) {
        dropdownItems.forEach(item => {
          item.classList.remove('is-open');
          const arrowBtn = item.querySelector('.nav-arrow-btn');
          if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'false');
        });
      }
    });

    // Close with Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        dropdownItems.forEach(item => {
          item.classList.remove('is-open');
          const arrowBtn = item.querySelector('.nav-arrow-btn');
          if (arrowBtn) arrowBtn.setAttribute('aria-expanded', 'false');
        });
      }
    });

    handleCategoryUrlParams();
  }

  function handleCategoryUrlParams() {
    if (window.location.pathname.includes('products.html')) {
      const params = new URLSearchParams(window.location.search);
      const cat = params.get('category');
      if (cat) {
        setTimeout(() => {
          const targetSidebarItem = document.querySelector(`.filter-category-item[data-category="${cat}"]`);
          if (targetSidebarItem) targetSidebarItem.click();
          const targetCardBtn = document.querySelector(`.cat-card-btn[data-pill="${cat}"]`);
          if (targetCardBtn) targetCardBtn.click();
        }, 120);
      }
    }

    if (window.location.pathname.includes('insights.html')) {
      const params = new URLSearchParams(window.location.search);
      const cat = params.get('category');
      if (cat) {
        setTimeout(() => {
          const targetMenuItem = document.querySelector(`.explore-menu-item[data-category="${cat}"]`);
          if (targetMenuItem) {
            const btn = targetMenuItem.querySelector('.explore-menu-btn');
            if (btn) btn.click();
          }
        }, 120);
      }
    }
  }

  // ==========================================================================
  // 2. MULTILINGUAL CONTROLLER & TRADE LOCALIZATION
  // ==========================================================================
  function initLanguageSelector() {
    const langBtn = document.getElementById('topLangBtn');
    if (!langBtn) return;

    // 1. Wrap button in .top-lang-wrap for absolute positioning
    let wrap = langBtn.closest('.top-lang-wrap');
    if (!wrap) {
      wrap = document.createElement('div');
      wrap.className = 'top-lang-wrap';
      langBtn.parentNode.insertBefore(wrap, langBtn);
      wrap.appendChild(langBtn);
    }

    // 2. Ensure chevron icon has .lang-chevron class
    let chevron = langBtn.querySelector('.fa-chevron-down, .lang-chevron');
    if (!chevron) {
      chevron = document.createElement('i');
      chevron.className = 'fa-solid fa-chevron-down lang-chevron';
      chevron.style.fontSize = '8.5px';
      chevron.style.opacity = '0.85';
      chevron.style.marginLeft = '4px';
      langBtn.appendChild(chevron);
    } else {
      chevron.classList.add('lang-chevron');
    }

    const currentLang = localStorage.getItem('concept_exim_lang') || 'en';

    // 3. Inject Dropdown Menu
    let dropdown = document.getElementById('topLangDropdown');
    if (!dropdown) {
      dropdown = document.createElement('div');
      dropdown.id = 'topLangDropdown';
      dropdown.className = 'top-lang-dropdown';
      dropdown.setAttribute('role', 'menu');
      dropdown.setAttribute('aria-label', 'Select Business Language');

      dropdown.innerHTML = `
        <div class="lang-dropdown-header">
          <span><i class="fa-solid fa-globe" style="color: #df8b1a; margin-right: 6px;"></i>Select Trade Language</span>
          <span class="lang-badge">10 Languages</span>
        </div>
        <div class="lang-dropdown-list">
          ${SUPPORTED_LANGUAGES.map(lang => `
            <button type="button" class="lang-option-btn ${lang.code === currentLang ? 'active' : ''}" data-lang="${lang.code}">
              <div class="lang-option-left">
                <span class="lang-flag-icon">${lang.flag}</span>
                <div class="lang-text-wrap">
                  <span class="lang-name-native">${lang.native}</span>
                  <span class="lang-name-sub">${lang.name} &bull; ${lang.region}</span>
                </div>
              </div>
              <i class="fa-solid fa-check lang-check-icon"></i>
            </button>
          `).join('')}
        </div>
        <div class="lang-dropdown-footer">
          <i class="fa-solid fa-circle-check"></i>
          <span>Instant trade portal localization active</span>
        </div>
      `;
      wrap.appendChild(dropdown);
    }

    // 4. Toggle dropdown on button click
    langBtn.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();

      const isOpen = dropdown.classList.contains('is-open');
      if (isOpen) {
        dropdown.classList.remove('is-open');
        langBtn.classList.remove('lang-open');
        langBtn.setAttribute('aria-expanded', 'false');
      } else {
        dropdown.classList.add('is-open');
        langBtn.classList.add('lang-open');
        langBtn.setAttribute('aria-expanded', 'true');
      }
    });

    // 5. Select Language
    dropdown.addEventListener('click', (e) => {
      const btn = e.target.closest('.lang-option-btn');
      if (!btn) return;

      e.preventDefault();
      e.stopPropagation();

      const langCode = btn.getAttribute('data-lang');
      if (langCode) {
        setLanguage(langCode, true);
        dropdown.classList.remove('is-open');
        langBtn.classList.remove('lang-open');
        langBtn.setAttribute('aria-expanded', 'false');
      }
    });

    // 6. Close when clicking outside
    document.addEventListener('click', (e) => {
      if (!wrap.contains(e.target)) {
        dropdown.classList.remove('is-open');
        langBtn.classList.remove('lang-open');
        langBtn.setAttribute('aria-expanded', 'false');
      }
    });

    // 7. Close with Escape key
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Escape') {
        dropdown.classList.remove('is-open');
        langBtn.classList.remove('lang-open');
        langBtn.setAttribute('aria-expanded', 'false');
      }
    });

    // Apply saved language on initial load
    setLanguage(currentLang, false);
  }

  // Set Language State, UI & Translations
  function setLanguage(langCode, showFeedback) {
    const lang = SUPPORTED_LANGUAGES.find(l => l.code === langCode) || SUPPORTED_LANGUAGES[0];
    localStorage.setItem('concept_exim_lang', lang.code);

    // Update Top Button Text
    const langBtn = document.getElementById('topLangBtn');
    if (langBtn) {
      const textSpan = langBtn.querySelector('span');
      if (textSpan) {
        textSpan.textContent = lang.native;
      }
      langBtn.setAttribute('title', `Active Trade Language: ${lang.native} (${lang.name})`);
    }

    // Update Active Pill in Dropdown
    const dropdown = document.getElementById('topLangDropdown');
    if (dropdown) {
      dropdown.querySelectorAll('.lang-option-btn').forEach(btn => {
        if (btn.getAttribute('data-lang') === lang.code) {
          btn.classList.add('active');
        } else {
          btn.classList.remove('active');
        }
      });
    }

    // Apply High-Speed Dictionary Translations
    applyDictionaryTranslations(lang.code);

    // Trigger Full-Page Google Translation Service
    triggerGoogleTranslate(lang.code);

    // Show User Feedback
    if (showFeedback) {
      const message = `Language switched to ${lang.flag} ${lang.native} (${lang.name})`;
      if (window.ConceptCart && typeof window.ConceptCart.showToast === 'function') {
        window.ConceptCart.showToast(message);
      } else {
        showGenericToast(message);
      }
    }
  }

  // Instant Dictionary Localization for Core UI
  function applyDictionaryTranslations(langCode) {
    const t = TRANSLATIONS[langCode] || TRANSLATIONS.en;

    // 1. Top Slim Bar Pillars
    const featureItems = document.querySelectorAll('.top-feature-item span');
    if (featureItems.length >= 4) {
      if (featureItems[0]) featureItems[0].textContent = t.globalReach;
      if (featureItems[1]) featureItems[1].textContent = t.trustedSuppliers;
      if (featureItems[2]) featureItems[2].textContent = t.qualityAssured;
      if (featureItems[3]) featureItems[3].textContent = t.onTimeDelivery;
    }

    // 2. Track Cargo Button
    const trackSpan = document.querySelector('#openTopTrackBtn span');
    if (trackSpan) trackSpan.textContent = t.trackCargo;

    // 3. Login / Register Button
    const loginSpan = document.querySelector('a[href="login.html"] span');
    if (loginSpan) loginSpan.textContent = t.loginRegister;

    // 4. Main Navbar Links
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
      const href = link.getAttribute('href') || '';
      const textSpan = link.querySelector('span:first-child');
      if (!textSpan) return;

      if (href.includes('index.html') || href === '#home') textSpan.textContent = t.home;
      else if (href.includes('about.html')) textSpan.textContent = t.about;
      else if (href.includes('products.html')) textSpan.textContent = t.products;
      else if (href.includes('services.html')) textSpan.textContent = t.services;
      else if (href.includes('global-presence.html')) textSpan.textContent = t.network;
      else if (href.includes('compliance.html')) textSpan.textContent = t.compliance;
      else if (href.includes('insights.html')) textSpan.textContent = t.insights;
      else if (href.includes('contact.html')) textSpan.textContent = t.contact;
    });

    // 5. Search Bar Input Placeholder
    const searchInputs = document.querySelectorAll('#mainSearchInput, #global-search-input');
    searchInputs.forEach(input => {
      input.placeholder = t.searchPlaceholder;
    });

    // 6. Request a Quote Buttons
    const quoteButtons = document.querySelectorAll('.btn-request-quote span, #btn-quote-hero-header span');
    quoteButtons.forEach(btn => {
      btn.textContent = t.requestQuote;
    });

    // 7. Direction & Lang attribute
    document.documentElement.lang = langCode;
    if (langCode === 'ar') {
      document.body.classList.add('lang-rtl');
    } else {
      document.body.classList.remove('lang-rtl');
    }
  }

  // Trigger Google Translate for Full Page Text
  function triggerGoogleTranslate(langCode) {
    const target = langCode === 'zh' ? 'zh-CN' : langCode;

    if (langCode === 'en') {
      document.cookie = 'googtrans=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;';
      document.cookie = 'googtrans=; expires=Thu, 01 Jan 1970 00:00:00 UTC; domain=' + window.location.hostname + '; path=/;';
    } else {
      document.cookie = 'googtrans=/en/' + target + '; path=/;';
      document.cookie = 'googtrans=/en/' + target + '; domain=' + window.location.hostname + '; path=/;';
    }

    if (!window.googleTranslateElementInit) {
      window.googleTranslateElementInit = function() {
        if (typeof google !== 'undefined' && google.translate) {
          new google.translate.TranslateElement({
            pageLanguage: 'en',
            includedLanguages: 'en,ar,es,fr,de,zh-CN,hi,ru,ja,pt',
            autoDisplay: false
          }, 'google_translate_element');
        }
      };

      if (!document.getElementById('google_translate_element')) {
        const gdiv = document.createElement('div');
        gdiv.id = 'google_translate_element';
        gdiv.style.display = 'none';
        document.body.appendChild(gdiv);
      }

      const script = document.createElement('script');
      script.type = 'text/javascript';
      script.src = '//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit';
      document.body.appendChild(script);
    } else {
      const select = document.querySelector('.goog-te-combo');
      if (select) {
        select.value = target;
        select.dispatchEvent(new Event('change'));
      }
    }
  }

  // Floating Toast Fallback
  function showGenericToast(message) {
    let toast = document.getElementById('conceptNavbarToast');
    if (!toast) {
      toast = document.createElement('div');
      toast.id = 'conceptNavbarToast';
      toast.className = 'concept-cart-toast';
      document.body.appendChild(toast);
    }
    toast.innerHTML = `<i class="fa-solid fa-globe toast-icon" style="color: #df8b1a;"></i><span>${message}</span>`;
    toast.classList.add('show');
    setTimeout(() => toast.classList.remove('show'), 3500);
  }

  // Global API
  window.ConceptLang = {
    setLanguage: setLanguage,
    getLanguages: () => [...SUPPORTED_LANGUAGES],
    getCurrentLanguage: () => localStorage.getItem('concept_exim_lang') || 'en'
  };

  // Self-initialize
  function initAll() {
    initNavbarDropdowns();
    initLanguageSelector();
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initAll);
  } else {
    initAll();
  }
})();
