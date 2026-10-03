// ==========================================================================
// KLANEXIM - Main Interactive Application Script
// ==========================================================================

document.addEventListener('DOMContentLoaded', () => {
  // --- Modals & Toasts Elements ---
  const quoteModal = document.getElementById('quote-modal');
  const searchModal = document.getElementById('search-modal');
  const quoteServiceSelect = document.getElementById('quote-service-select');
  const quoteForm = document.getElementById('quote-form');
  const toast = document.getElementById('toast-notification');
  const toastMsg = document.getElementById('toast-message');

  // --- Search Elements ---
  const btnSearchModal = document.getElementById('btn-search-modal');
  const globalSearchInput = document.getElementById('global-search-input');
  const searchResultsList = document.getElementById('search-results-list');
  const searchPills = document.querySelectorAll('.search-pill');

  // --- Quote Trigger Buttons ---
  const quoteButtons = [
    document.getElementById('btn-quote-hero-header'),
    document.getElementById('hero-custom-quote-btn'),
    document.getElementById('btn-footer-quote')
  ];

  // Data items for search
  const searchableCatalogue = [
    { title: 'Import Solutions', category: 'Services', desc: 'Quality products from global markets with complete customs clearance.', link: '#services' },
    { title: 'Export Management', category: 'Services', desc: 'Take your business to new international destinations seamlessly.', link: '#services' },
    { title: 'Global Sourcing', category: 'Services', desc: 'Reliable suppliers and verified manufacturing partners with better value.', link: '#services' },
    { title: 'Logistics Coordination', category: 'Services', desc: 'Smooth multimodal freight movement across air, ocean and land.', link: '#services' },
    { title: 'Customs Support', category: 'Services', desc: 'Compliance made simple with regulatory duty optimization.', link: '#services' },
    { title: 'Trade Consulting', category: 'Services', desc: 'Expert trade guidance, risk mitigation and lasting international partnerships.', link: '#services' },
    { title: 'Agriculture', category: 'Products', desc: 'Fresh organic grains, wheat, spices, basmati rice, fruits & vegetables.', link: '#products' },
    { title: 'Industrial Materials', category: 'Products', desc: 'High grade steel cylinders, metallurgy, industrial polymers and raw materials.', link: '#products' },
    { title: 'Food Commodities', category: 'Products', desc: 'Processed foods, natural spices, herbs, pulses, oils and packaged commodities.', link: '#products' },
    { title: 'Textiles & Apparel', category: 'Products', desc: 'Cotton fabrics, woven rolls, fashion apparel and premium leather goods.', link: '#products' },
    { title: 'Machinery & Equipment', category: 'Products', desc: 'Heavy engineering turbines, precision CNC components, generator machinery.', link: '#products' },
    { title: 'Energy Products', category: 'Products', desc: 'Renewable solar panels, petroleum lubricants, sustainable energy products.', link: '#products' }
  ];

  // --- Helper: Toast Notification ---
  function showToast(message) {
    if (!toast || !toastMsg) return;
    toastMsg.textContent = message;
    toast.classList.add('show');
    setTimeout(() => {
      toast.classList.remove('show');
    }, 3600);
  }

  // --- Modal Open / Close Helpers ---
  function openQuoteModal(serviceName = null) {
    if (quoteModal) {
      if (serviceName && quoteServiceSelect) {
        // Set matching option
        for (let opt of quoteServiceSelect.options) {
          if (opt.value.toLowerCase().includes(serviceName.toLowerCase()) || serviceName.toLowerCase().includes(opt.value.toLowerCase())) {
            quoteServiceSelect.value = opt.value;
            break;
          }
        }
      }
      quoteModal.classList.add('active');
    }
  }

  function closeModals() {
    if (quoteModal) quoteModal.classList.remove('active');
    if (searchModal) searchModal.classList.remove('active');
  }

  // --- Bind Quote Triggers ---
  quoteButtons.forEach(btn => {
    if (btn) {
      btn.addEventListener('click', (e) => {
        e.preventDefault();
        openQuoteModal();
      });
    }
  });

  // --- Bind Service Cards Click to Open Quote ---
  document.querySelectorAll('.service-card').forEach(card => {
    card.addEventListener('click', () => {
      const serviceName = card.getAttribute('data-service') || 'General RFQ';
      openQuoteModal(serviceName);
      showToast(`Selected "${serviceName}". Complete RFQ form to get quote.`);
    });
  });

  // --- Bind Sector Cards Click to Filter / Scroll ---
  document.querySelectorAll('.sector-card').forEach(card => {
    card.addEventListener('click', () => {
      const sectorName = card.getAttribute('data-sector') || 'Products';
      openQuoteModal(sectorName);
      showToast(`Selected "${sectorName}" sector. Tell us your volume needs.`);
    });
  });

  // --- Modal Close Buttons ---
  const closeQuoteBtn = document.getElementById('modal-close-quote');
  const cancelQuoteBtn = document.getElementById('btn-cancel-quote');
  const closeSearchBtn = document.getElementById('modal-close-search');

  if (closeQuoteBtn) closeQuoteBtn.addEventListener('click', closeModals);
  if (cancelQuoteBtn) cancelQuoteBtn.addEventListener('click', closeModals);
  if (closeSearchBtn) closeSearchBtn.addEventListener('click', closeModals);

  // Close modals when clicking backdrop
  [quoteModal, searchModal].forEach(modal => {
    if (modal) {
      modal.addEventListener('click', (e) => {
        if (e.target === modal) closeModals();
      });
    }
  });

  // Escape key to close modals
  document.addEventListener('keydown', (e) => {
    if (e.key === 'Escape') closeModals();
  });

  // --- Quote Form Submit ---
  if (quoteForm) {
    quoteForm.addEventListener('submit', (e) => {
      e.preventDefault();
      closeModals();
      showToast('Thank you! Your quote request has been dispatched to CONCEPT EXIM trade specialists.');
      quoteForm.reset();
    });
  }

  // --- Search Modal Trigger & Functionality ---
  if (btnSearchModal && searchModal) {
    btnSearchModal.addEventListener('click', (e) => {
      e.preventDefault();
      searchModal.classList.add('active');
      if (globalSearchInput) {
        setTimeout(() => globalSearchInput.focus(), 150);
      }
    });
  }

  function renderSearchResults(query) {
    if (!searchResultsList) return;
    const cleanQuery = query.toLowerCase().trim();

    if (!cleanQuery) {
      searchResultsList.innerHTML = `
        <div class="search-empty-state">
          <i class="fa-solid fa-boxes-packing"></i>
          <p>Type keywords to search across KlanExim global trade catalogue.</p>
        </div>
      `;
      return;
    }

    const matches = searchableCatalogue.filter(item => 
      item.title.toLowerCase().includes(cleanQuery) ||
      item.category.toLowerCase().includes(cleanQuery) ||
      item.desc.toLowerCase().includes(cleanQuery)
    );

    if (matches.length === 0) {
      searchResultsList.innerHTML = `
        <div class="search-empty-state">
          <i class="fa-solid fa-magnifying-glass"></i>
          <p>No trade items found for "${cleanQuery}". Try "Import", "Agriculture", "Customs", or "Steel".</p>
        </div>
      `;
      return;
    }

    searchResultsList.innerHTML = matches.map(item => `
      <div class="search-result-item" data-link="${item.link}" data-title="${item.title}">
        <div style="font-size: 1.2rem; color: var(--gold-primary);"><i class="fa-solid ${item.category === 'Services' ? 'fa-truck-ramp-box' : 'fa-box-open'}"></i></div>
        <div style="flex: 1;">
          <div class="search-result-title">${item.title} <span style="font-size: 0.7rem; color: var(--gold-primary); background: rgba(197, 138, 54, 0.1); padding: 2px 6px; border-radius: 4px; margin-left: 6px;">${item.category}</span></div>
          <div class="search-result-meta">${item.desc}</div>
        </div>
        <i class="fa-solid fa-chevron-right" style="color: #cbd5e1; font-size: 0.8rem;"></i>
      </div>
    `).join('');

    // Bind item click
    document.querySelectorAll('.search-result-item').forEach(el => {
      el.addEventListener('click', () => {
        const link = el.getAttribute('data-link');
        const title = el.getAttribute('data-title');
        closeModals();
        if (link) {
          const targetEl = document.querySelector(link);
          if (targetEl) targetEl.scrollIntoView({ behavior: 'smooth' });
        }
        showToast(`Jumped to ${title}`);
      });
    });
  }

  if (globalSearchInput) {
    globalSearchInput.addEventListener('input', (e) => {
      renderSearchResults(e.target.value);
    });
  }

  // Bind Header Search Input to open search modal seamlessly
  const mainSearchInput = document.getElementById('mainSearchInput');
  if (mainSearchInput && searchModal) {
    mainSearchInput.addEventListener('click', (e) => {
      e.preventDefault();
      searchModal.classList.add('active');
      if (globalSearchInput) {
        globalSearchInput.value = mainSearchInput.value;
        renderSearchResults(mainSearchInput.value);
        setTimeout(() => globalSearchInput.focus(), 120);
      }
    });

    mainSearchInput.addEventListener('input', (e) => {
      searchModal.classList.add('active');
      if (globalSearchInput) {
        globalSearchInput.value = e.target.value;
        renderSearchResults(e.target.value);
        setTimeout(() => globalSearchInput.focus(), 120);
      }
    });
  }

  // Ctrl + K / Cmd + K global shortcut
  document.addEventListener('keydown', (e) => {
    if ((e.ctrlKey || e.metaKey) && e.key.toLowerCase() === 'k') {
      e.preventDefault();
      if (searchModal) {
        searchModal.classList.toggle('active');
        if (searchModal.classList.contains('active') && globalSearchInput) {
          setTimeout(() => globalSearchInput.focus(), 120);
        }
      }
    }
  });

  searchPills.forEach(pill => {
    pill.addEventListener('click', () => {
      const term = pill.getAttribute('data-term');
      if (globalSearchInput) {
        globalSearchInput.value = term;
        renderSearchResults(term);
      }
    });
  });

  // --- Language Toggle Demo ---
  const btnLangToggle = document.getElementById('btn-lang-toggle');
  if (btnLangToggle) {
    btnLangToggle.addEventListener('click', () => {
      const span = btnLangToggle.querySelector('span');
      if (span.textContent === 'English') {
        span.textContent = 'العربية (Arabic)';
        showToast('Language changed to Arabic (Global Hub Mode)');
      } else if (span.textContent === 'العربية (Arabic)') {
        span.textContent = 'Deutsch';
        showToast('Language changed to German (EU Hub Mode)');
      } else {
        span.textContent = 'English';
        showToast('Language switched to English (Default)');
      }
    });
  }

  // --- Mobile Menu Toggle ---
  const btnMobileToggle = document.getElementById('btn-mobile-toggle');
  const mainNav = document.getElementById('main-nav');
  if (btnMobileToggle && mainNav) {
    btnMobileToggle.addEventListener('click', () => {
      const isVisible = mainNav.style.display === 'flex';
      if (isVisible) {
        mainNav.style.display = 'none';
      } else {
        mainNav.style.display = 'flex';
        mainNav.style.flexDirection = 'column';
        mainNav.style.position = 'absolute';
        mainNav.style.top = '100%';
        mainNav.style.left = '0';
        mainNav.style.width = '100%';
        mainNav.style.background = '#ffffff';
        mainNav.style.padding = '20px';
        mainNav.style.boxShadow = '0 10px 25px rgba(0,0,0,0.1)';
      }
    });
  }

  // --- Active Nav Link on Scroll ---
  const navLinks = document.querySelectorAll('.main-nav .nav-item');
  const sections = document.querySelectorAll('section, footer');

  window.addEventListener('scroll', () => {
    let current = '';
    const scrollPos = window.scrollY + 100;

    sections.forEach(section => {
      const sectionTop = section.offsetTop;
      const sectionHeight = section.clientHeight;
      if (scrollPos >= sectionTop && scrollPos < sectionTop + sectionHeight) {
        current = section.getAttribute('id');
      }
    });

    navLinks.forEach(link => {
      link.classList.remove('active');
      const href = link.getAttribute('href');
      if (href === `#${current}` || (current === 'home' && href === 'index.html')) {
        link.classList.add('active');
      }
    });
  });

  // --- Service Cards Navigation ---
  const serviceCards = document.querySelectorAll('.service-card');

  serviceCards.forEach(card => {
    card.addEventListener('click', (e) => {
      // Do not interfere if user clicked an explicit link
      if (e.target.closest('a') && !e.target.closest('.service-action-wrap')) return;
      const serviceName = card.getAttribute('data-service');
      if (serviceName) {
        window.location.href = `services.html#${encodeURIComponent(serviceName.toLowerCase().replace(/\s+/g, '-'))}`;
      }
    });
  });

});
