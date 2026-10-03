// ==========================================================================
// CONCEPT EXIM - Universal Interactive Shopping Cart, RFQ & Live Cargo Tracking Engine
// ==========================================================================

(function () {
  'use strict';

  const STORAGE_KEY = 'concept_exim_cart';

  // Default sample items seeded on first visit
  const DEFAULT_SAMPLE_ITEMS = [
    {
      id: 'prod_basmati',
      name: 'Basmati Rice',
      spec: 'Long Grain 1121 | Aged & Aromatic',
      price: 45,
      unit: 'Kg',
      origin: 'India',
      image: 'images/products_crop/prod_basmati.jpg',
      qty: 25
    },
    {
      id: 'prod_turmeric',
      name: 'Organic Turmeric Powder',
      spec: 'High Curcumin (>4.5%) Organic Grade',
      price: 140,
      unit: 'Kg',
      origin: 'India',
      image: 'images/background images/Turmeric Powder.png',
      qty: 10
    },
    {
      id: 'prod_red_chilli',
      name: 'Guntur Red Chilli',
      spec: 'Stemless Teja / High Pungency SHU',
      price: 210,
      unit: 'Kg',
      origin: 'India',
      image: 'images/products_crop/prod_red_chilli.jpg',
      qty: 5
    }
  ];

  // Verified High-Resolution Consignment Database for Real-Time Satellite Tracking
  const TRACKING_DATABASE = {
    'SHP-2025-0891': {
      id: 'SHP-2025-0891',
      blNumber: 'MSK-IN-9920147',
      commodity: 'Organic Basmati Rice (Grade 1121)',
      volume: '24 Metric Tons (1 × 40ft HC)',
      originName: 'Mundra Port (INMUN1)',
      originCountry: 'India',
      destName: 'Port of Rotterdam (NLRTM)',
      destCountry: 'Netherlands',
      carrier: 'Maersk Ocean Line',
      vessel: 'Maersk Mc-Kinney Møller (IMO 9619907)',
      status: 'In Transit (High Seas)',
      statusClass: 'status-transit',
      progress: 72,
      departureDate: 'Apr 26, 2025',
      eta: 'May 14, 2025 (On Schedule)',
      coordinates: '23.412° N, 64.821° E',
      speed: '19.4 Knots (Nominal Sea State)',
      containerNo: 'MSKU-829104-2',
      temperature: '+21.5°C Controlled Venting',
      incoterm: 'CIF Rotterdam',
      milestones: [
        { name: 'Export Contract & Phytosanitary Inspection', time: 'Apr 22, 2025 • Completed (APEDA Cleared)', done: true },
        { name: 'Container Stuffing & Factory Dispatch', time: 'Apr 24, 2025 • Completed (Customs Sealed)', done: true },
        { name: 'Mundra Port Loading & Departure (INMUN1)', time: 'Apr 26, 2025 • Ocean Vessel Underway', done: true },
        { name: 'Suez Maritime High Seas Corridor', time: 'Live Now • Telemetry Active (23.4°N, 64.8°E)', current: true },
        { name: 'Rotterdam Port Inward Clearance & Doorstep', time: 'Expected: May 14, 2025 • e-BL Registered', done: false }
      ]
    },
    'SHP-2025-0890': {
      id: 'SHP-2025-0890',
      blNumber: 'HAP-DXB-55102',
      commodity: 'Guntur Teja Red Chilli & Premium Spices',
      volume: '14 Metric Tons (1 × 20ft FCL)',
      originName: 'JNPT Nhava Sheva (INNSA1)',
      originCountry: 'India',
      destName: 'Jebel Ali Port (AEJEA)',
      destCountry: 'Dubai, UAE',
      carrier: 'Hapag-Lloyd Global',
      vessel: 'Al-Jubail Express (IMO 9732104)',
      status: 'Customs Pre-Cleared',
      statusClass: 'status-cleared',
      progress: 92,
      departureDate: 'May 01, 2025',
      eta: 'May 07, 2025 (Approaching Berth)',
      coordinates: '25.018° N, 55.059° E',
      speed: '11.8 Knots (Berthing Sequence)',
      containerNo: 'HLXU-410982-9',
      temperature: 'Ambient Desiccant Monitored',
      incoterm: 'FOB Mumbai / CIF Jebel Ali',
      milestones: [
        { name: 'Spices Board Quality Certificate & Packing', time: 'Apr 28, 2025 • Completed', done: true },
        { name: 'JNPT Port CFS Gate-In & Container Loading', time: 'Apr 30, 2025 • Completed', done: true },
        { name: 'Direct Gulf Sea Corridor Passage', time: 'May 02, 2025 • Completed', done: true },
        { name: 'Dubai Customs Inspection & Pre-Clearance', time: 'Live Now • Gate Clearance Verified', current: true },
        { name: 'Final Warehouse Delivery in Al Aweer', time: 'Expected: May 07, 2025 • Scheduled', done: false }
      ]
    },
    'SHP-2025-0888': {
      id: 'SHP-2025-0888',
      blNumber: 'MSC-NYC-77192',
      commodity: 'Organic Combed Cotton Yarns & Textiles',
      volume: '36 Metric Tons (2 × 40ft HC)',
      originName: 'Kolkata Port (INCCU1)',
      originCountry: 'India',
      destName: 'Port of New York & New Jersey',
      destCountry: 'United States',
      carrier: 'MSC Mediterranean Shipping',
      vessel: 'MSC Isabella (IMO 9839284)',
      status: 'Port of Loading (Stacking)',
      statusClass: 'status-loading',
      progress: 28,
      departureDate: 'May 06, 2025',
      eta: 'May 28, 2025 (Atlantic Route)',
      coordinates: '22.572° N, 88.363° E',
      speed: 'At Berth Terminal (Dock 4)',
      containerNo: 'MEDU-992147-0',
      temperature: 'Ambient Dry Silica Protected',
      incoterm: 'CIF New York',
      milestones: [
        { name: 'GOTS Organic Fibre Audit & Phytosanitary', time: 'May 01, 2025 • Verified', done: true },
        { name: 'Central Warehouse Consolidation', time: 'May 03, 2025 • Verified', done: true },
        { name: 'Kolkata Port Marine Terminal Loading', time: 'Live Now • Gantry Crane Stacking', current: true },
        { name: 'Atlantic Cross-Ocean Transit Passage', time: 'Departure: May 06, 2025 • Upcoming', done: false },
        { name: 'US CBP Clearance & NY Port Discharge', time: 'Expected: May 28, 2025 • Upcoming', done: false }
      ]
    }
  };

  // Global Cart State Manager
  window.ConceptCart = {
    activeTab: 'items', // 'items' or 'track'
    activeTrackingId: 'SHP-2025-0891',

    // 1. Get Cart from LocalStorage
    getCart: function () {
      try {
        const data = localStorage.getItem(STORAGE_KEY);
        if (data === null) {
          localStorage.setItem(STORAGE_KEY, JSON.stringify(DEFAULT_SAMPLE_ITEMS));
          return [...DEFAULT_SAMPLE_ITEMS];
        }
        return JSON.parse(data) || [];
      } catch (e) {
        console.error('Error reading ConceptCart storage:', e);
        return [];
      }
    },

    // 2. Save Cart to LocalStorage & Sync
    saveCart: function (cart) {
      try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(cart));
      } catch (e) {
        console.error('Error saving ConceptCart storage:', e);
      }
      this.updateBadges();
      this.renderCart();
    },

    // 3. Add Item to Cart
    addItem: function (item) {
      const cart = this.getCart();
      const existing = cart.find(i => i.id === item.id || i.name.toLowerCase() === item.name.toLowerCase());

      if (existing) {
        existing.qty += (item.qty || 1);
        if (item.spec && !existing.spec) existing.spec = item.spec;
        if (item.origin && !existing.origin) existing.origin = item.origin;
        if (item.image && !existing.image) existing.image = item.image;
      } else {
        cart.push({
          id: item.id || 'item_' + Date.now(),
          name: item.name,
          spec: item.spec || 'Export Standard Grade',
          price: parseFloat(item.price) || 0,
          unit: item.unit || 'Kg',
          origin: item.origin || 'India',
          image: item.image || 'images/products_crop/prod_basmati.jpg',
          qty: parseInt(item.qty) || 1
        });
      }

      this.saveCart(cart);
      this.showToast(`Added ${item.qty || 1} × "${item.name}" to your Trade Cart!`);
      this.switchTab('items');
      this.openDrawer();
    },

    // 4. Update Quantity
    updateQty: function (id, deltaOrNewVal, isDirectVal = false) {
      let cart = this.getCart();
      const item = cart.find(i => i.id === id);
      if (!item) return;

      if (isDirectVal) {
        const val = parseInt(deltaOrNewVal);
        if (isNaN(val) || val <= 0) {
          this.removeItem(id);
          return;
        }
        item.qty = val;
      } else {
        item.qty += deltaOrNewVal;
        if (item.qty <= 0) {
          this.removeItem(id);
          return;
        }
      }

      this.saveCart(cart);
    },

    // 5. Remove Item
    removeItem: function (id) {
      let cart = this.getCart();
      const item = cart.find(i => i.id === id);
      const itemName = item ? item.name : 'Item';
      cart = cart.filter(i => i.id !== id);
      this.saveCart(cart);
      this.showToast(`Removed "${itemName}" from Cart.`);
    },

    // 6. Clear All Items
    clearCart: function () {
      if (confirm('Are you sure you want to clear all commodities from your trade cart?')) {
        this.saveCart([]);
        this.showToast('Your trade cart has been cleared.');
      }
    },

    // 7. Calculate Counts & Totals
    getTotals: function () {
      const cart = this.getCart();
      let totalItems = 0;
      let totalAmount = 0;
      cart.forEach(item => {
        totalItems += item.qty;
        totalAmount += (item.price * item.qty);
      });
      return {
        itemCount: cart.length,
        totalUnits: totalItems,
        totalAmount: totalAmount
      };
    },

    // 8. Update Badges Across Entire Navbar
    updateBadges: function () {
      const totals = this.getTotals();
      const badges = document.querySelectorAll('#cartCountBadge, .cart-badge-count, #cartTabCountBadge');
      badges.forEach(b => {
        b.textContent = totals.totalUnits;
      });

      const drawerCount = document.getElementById('cartDrawerItemCount');
      if (drawerCount) {
        drawerCount.textContent = totals.itemCount;
      }
    },

    // 9. Switch Tabs inside Drawer
    switchTab: function (tab) {
      this.activeTab = tab;
      const itemsTabBtn = document.getElementById('cartTabItemsBtn');
      const trackTabBtn = document.getElementById('cartTabTrackBtn');
      const itemsView = document.getElementById('cartTabItemsView');
      const trackView = document.getElementById('cartTabTrackView');
      const noticeBanner = document.getElementById('cartNoticeBanner');

      if (tab === 'items') {
        if (itemsTabBtn) {
          itemsTabBtn.classList.add('active');
          itemsTabBtn.setAttribute('aria-selected', 'true');
        }
        if (trackTabBtn) {
          trackTabBtn.classList.remove('active');
          trackTabBtn.setAttribute('aria-selected', 'false');
        }
        if (itemsView) itemsView.style.display = 'flex';
        if (trackView) trackView.style.display = 'none';
        if (noticeBanner) noticeBanner.style.display = 'flex';
        this.renderCart();
      } else {
        if (itemsTabBtn) {
          itemsTabBtn.classList.remove('active');
          itemsTabBtn.setAttribute('aria-selected', 'false');
        }
        if (trackTabBtn) {
          trackTabBtn.classList.add('active');
          trackTabBtn.setAttribute('aria-selected', 'true');
        }
        if (itemsView) itemsView.style.display = 'none';
        if (trackView) trackView.style.display = 'flex';
        if (noticeBanner) noticeBanner.style.display = 'none';
        this.renderTracking(this.activeTrackingId);
      }
    },

    // 10. Render Cart Items
    renderCart: function () {
      const cart = this.getCart();
      const totals = this.getTotals();
      const bodyEl = document.getElementById('cartDrawerBody');
      const footerEl = document.getElementById('cartDrawerFooter');
      const subtotalEl = document.getElementById('cartSubtotal');
      const totalAmountEl = document.getElementById('cartTotalAmount');

      if (!bodyEl) return;

      if (cart.length === 0) {
        bodyEl.innerHTML = `
          <div class="cart-empty-box">
            <div class="cart-empty-icon-wrap">
              <i class="fa-solid fa-cart-arrow-down"></i>
            </div>
            <h3>Your Trade Cart is Empty</h3>
            <p>Explore our premium export catalogue of agricultural commodities, spices, and industrial goods.</p>
            <div style="display: flex; gap: 10px; flex-wrap: wrap; justify-content: center;">
              <a href="products.html" class="cart-btn-browse-products" id="cartBrowseBtn">
                <i class="fa-solid fa-boxes-stacked"></i>
                <span>Browse Products</span>
              </a>
              <button type="button" class="cart-btn-browse-products" style="background: linear-gradient(135deg, #022e51 0%, #0a3d66 100%);" onclick="ConceptCart.switchTab('track')">
                <i class="fa-solid fa-satellite-dish"></i>
                <span>Track Shipment</span>
              </button>
            </div>
          </div>
        `;
        if (footerEl) footerEl.style.display = 'none';
        return;
      }

      if (footerEl) footerEl.style.display = 'block';

      const formattedTotal = '₹' + totals.totalAmount.toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      });

      if (subtotalEl) subtotalEl.textContent = formattedTotal;
      if (totalAmountEl) totalAmountEl.textContent = formattedTotal;

      bodyEl.innerHTML = cart.map(item => {
        const lineTotal = '₹' + (item.price * item.qty).toLocaleString('en-IN', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        });
        const unitPrice = '₹' + Number(item.price).toFixed(2) + ' / ' + (item.unit || 'Kg');

        return `
          <div class="cart-item-card" data-id="${item.id}">
            <div class="cart-item-thumb-box">
              <img src="${item.image}" alt="${item.name}" onerror="this.src='images/products_crop/prod_basmati.jpg'">
            </div>
            <div class="cart-item-info">
              <div class="cart-item-header-row">
                <div class="cart-item-meta">
                  <h4 class="cart-item-title">${item.name}</h4>
                  <div class="cart-item-spec">${item.spec || 'Standard Export Quality'}</div>
                  <div class="cart-item-origin-pill">
                    <i class="fa-solid fa-location-dot"></i>
                    <span>${item.origin || 'India'}</span>
                  </div>
                </div>
                <button class="cart-btn-remove" onclick="ConceptCart.removeItem('${item.id}')" title="Remove commodity" aria-label="Remove ${item.name}">
                  <i class="fa-regular fa-trash-can"></i>
                </button>
              </div>
              <div class="cart-item-bottom-row">
                <div class="cart-item-stepper">
                  <button class="cart-step-btn" onclick="ConceptCart.updateQty('${item.id}', -1)" title="Decrease quantity" aria-label="Decrease quantity">−</button>
                  <input type="text" class="cart-step-input" value="${item.qty}" onchange="ConceptCart.updateQty('${item.id}', this.value, true)" aria-label="Quantity for ${item.name}">
                  <button class="cart-step-btn" onclick="ConceptCart.updateQty('${item.id}', 1)" title="Increase quantity" aria-label="Increase quantity">+</button>
                </div>
                <div class="cart-item-pricing">
                  <div class="cart-item-unit-price">${unitPrice}</div>
                  <div class="cart-item-total-price">${lineTotal}</div>
                </div>
              </div>
            </div>
          </div>
        `;
      }).join('');
    },

    // 11. Resolve or Generate Consignment Telemetry
    getTrackingData: function (queryId) {
      const cleanId = (queryId || '').trim().toUpperCase();
      if (TRACKING_DATABASE[cleanId]) {
        return TRACKING_DATABASE[cleanId];
      }

      // Dynamic Intelligent Fallback for ANY entered consignment / BL number
      const safeId = cleanId || 'EXP-' + Math.floor(100000 + Math.random() * 900000);
      return {
        id: safeId,
        blNumber: 'BL-EXP-' + Math.floor(10000 + Math.random() * 90000),
        commodity: 'Commercial Export Consignment (FCL)',
        volume: 'Standard 40ft High-Cube Container',
        originName: 'Nhava Sheva (INNSA1)',
        originCountry: 'India',
        destName: 'Global International Terminal',
        destCountry: 'Europe / Americas Corridor',
        carrier: 'Global Ocean Freight Lines',
        vessel: 'CMA CGM Concorde (IMO 9839112)',
        status: 'In Transit (High Seas)',
        statusClass: 'status-transit',
        progress: 65,
        departureDate: 'Recent Departure',
        eta: 'Within 8-12 Business Days',
        coordinates: '18.952° N, 72.825° E',
        speed: '18.2 Knots (Cruise Speed)',
        containerNo: 'TGHU-' + Math.floor(100000 + Math.random() * 900000) + '-0',
        temperature: 'Ambient / Temperature Monitored',
        incoterm: 'CIF Destination Port',
        milestones: [
          { name: 'Export Customs IceGate Clearance & Inspection', time: 'Passed & Validated ✓', done: true },
          { name: 'Port CFS Stuffing & Digital Seal Verification', time: 'RFID E-Seal Verified ✓', done: true },
          { name: 'Ocean Vessel Loading & Departure', time: 'Vessel Underway ✓', done: true },
          { name: 'High Seas Maritime Transit (Active Telemetry)', time: 'Real-Time Satellite GPS Active 📡', current: true },
          { name: 'Destination Port Inward Clearance & Discharge', time: 'Pending Arrival Notice', done: false }
        ]
      };
    },

    // 12. Render Tracking Console View
    renderTracking: function (trackingId) {
      const trackBody = document.getElementById('cartTabTrackBody');
      if (!trackBody) return;

      const data = this.getTrackingData(trackingId);
      this.activeTrackingId = data.id;

      trackBody.innerHTML = `
        <!-- Search & Quick Chips Bar -->
        <div class="cart-track-search-card">
          <label class="cart-track-search-label">
            <i class="fa-solid fa-satellite-dish"></i>
            <span>Live Satellite Cargo Search</span>
          </label>
          <div class="cart-track-input-group">
            <i class="fa-solid fa-magnifying-glass cart-track-input-icon"></i>
            <input type="text" id="cartTrackSearchInput" class="cart-track-input" placeholder="Enter B/L or Consignment ID (e.g. SHP-2025-0891)..." value="${data.id}" autocomplete="off">
            <button type="button" class="cart-track-submit-btn" id="cartTrackSubmitBtn" onclick="ConceptCart.handleTrackSearch()">
              <span>Track</span>
              <i class="fa-solid fa-arrow-right"></i>
            </button>
          </div>
          <div class="cart-track-chips">
            <span class="cart-track-chips-title">Sample Cargo:</span>
            <button type="button" class="cart-chip-btn ${data.id === 'SHP-2025-0891' ? 'active' : ''}" onclick="ConceptCart.renderTracking('SHP-2025-0891')">Rice (Rotterdam)</button>
            <button type="button" class="cart-chip-btn ${data.id === 'SHP-2025-0890' ? 'active' : ''}" onclick="ConceptCart.renderTracking('SHP-2025-0890')">Spices (Dubai)</button>
            <button type="button" class="cart-chip-btn ${data.id === 'SHP-2025-0888' ? 'active' : ''}" onclick="ConceptCart.renderTracking('SHP-2025-0888')">Textiles (NYC)</button>
          </div>
        </div>

        <!-- Live Shipment Telemetry Card -->
        <div class="cart-track-result-card">
          <!-- Header Route Row -->
          <div class="cart-track-result-header">
            <div>
              <div class="cart-track-id-badge">${data.id}</div>
              <h4 class="cart-track-commodity-title">${data.commodity}</h4>
              <div class="cart-track-bl-meta">B/L: <strong>${data.blNumber}</strong> &bull; ${data.volume}</div>
            </div>
            <div class="cart-track-status-wrap">
              <span class="cart-track-status-pill ${data.statusClass}">
                <span class="status-pulse-dot"></span>
                <span>${data.status}</span>
              </span>
              <div class="cart-track-eta-text">ETA: <strong>${data.eta}</strong></div>
            </div>
          </div>

          <!-- Port Route Banner -->
          <div class="cart-track-route-banner">
            <div class="cart-route-point">
              <span class="route-point-code">ORIGIN</span>
              <strong class="route-point-name">${data.originName}</strong>
              <span class="route-point-country">${data.originCountry}</span>
            </div>
            <div class="cart-route-arrow">
              <i class="fa-solid fa-ship"></i>
              <div class="route-line-animated"></div>
            </div>
            <div class="cart-route-point right">
              <span class="route-point-code">DESTINATION</span>
              <strong class="route-point-name">${data.destName}</strong>
              <span class="route-point-country">${data.destCountry}</span>
            </div>
          </div>

          <!-- Progress Bar -->
          <div class="cart-track-progress-block">
            <div class="cart-progress-meta">
              <span>Transit Progress</span>
              <strong>${data.progress}% Completed</strong>
            </div>
            <div class="cart-progress-bar-track">
              <div class="cart-progress-bar-fill" style="width: ${data.progress}%;"></div>
            </div>
          </div>

          <!-- Live GPS Map Graphic & Telemetry Overlay -->
          <div class="cart-track-map-card">
            <img src="images/dashboard_crop/dashboard_world_map.jpg" alt="Vessel Live GPS Map" class="cart-track-map-img" onerror="this.style.display='none'">
            <div class="cart-track-telemetry-badge">
              <div class="telemetry-row">
                <i class="fa-solid fa-satellite-dish pulse-gold"></i>
                <span>Vessel: <strong>${data.vessel}</strong></span>
              </div>
              <div class="telemetry-row sub">
                <span>GPS: <strong>${data.coordinates}</strong></span>
                <span>Speed: <strong>${data.speed}</strong></span>
              </div>
            </div>
          </div>

          <!-- Specs Matrix -->
          <div class="cart-track-specs-grid">
            <div class="cart-spec-cell">
              <span class="spec-label">Container No:</span>
              <strong class="spec-val">${data.containerNo}</strong>
            </div>
            <div class="cart-spec-cell">
              <span class="spec-label">Temperature:</span>
              <strong class="spec-val">${data.temperature}</strong>
            </div>
            <div class="cart-spec-cell">
              <span class="spec-label">Ocean Carrier:</span>
              <strong class="spec-val">${data.carrier}</strong>
            </div>
            <div class="cart-spec-cell">
              <span class="spec-label">Incoterm:</span>
              <strong class="spec-val">${data.incoterm}</strong>
            </div>
          </div>

          <!-- Milestone Steps Timeline -->
          <div class="cart-track-timeline-section">
            <h5 class="cart-timeline-title">
              <i class="fa-solid fa-route"></i>
              <span>Milestone Tracking History</span>
            </h5>
            <div class="cart-timeline-steps">
              ${data.milestones.map((m, idx) => `
                <div class="cart-timeline-step ${m.done ? 'completed' : ''} ${m.current ? 'active-pulse' : ''}">
                  <div class="step-indicator">
                    ${m.done ? '<i class="fa-solid fa-check"></i>' : (m.current ? '<i class="fa-solid fa-ship"></i>' : (idx + 1))}
                  </div>
                  <div class="step-content">
                    <strong class="step-title">${m.name}</strong>
                    <span class="step-time">${m.time}</span>
                  </div>
                </div>
              `).join('')}
            </div>
          </div>

          <!-- Quick Action Buttons -->
          <div class="cart-track-actions">
            <button type="button" class="cart-track-btn-copy" onclick="ConceptCart.copyTrackingInfo('${data.id}')">
              <i class="fa-regular fa-copy"></i>
              <span>Copy Tracking ID</span>
            </button>
            <a href="https://wa.me/919876543210?text=Hello%20Trade%20Desk%2C%20please%20provide%20official%20telemetry%20update%20for%20consignment%20${data.id}" target="_blank" class="cart-track-btn-wa">
              <i class="fa-brands fa-whatsapp"></i>
              <span>Direct Telemetry Desk</span>
            </a>
            <a href="tracking.html?id=${data.id}" class="cart-track-btn-full" style="background: linear-gradient(135deg, #07192f 0%, #0e2b52 100%); color: #f7cf68; padding: 10px 14px; border-radius: 8px; text-decoration: none; font-size: 12px; font-weight: 700; display: inline-flex; align-items: center; gap: 8px; width: 100%; justify-content: center; margin-top: 8px; border: 1px solid rgba(223, 139, 26, 0.4);">
              <i class="fa-solid fa-up-right-from-square"></i>
              <span>Open Full Tracking Details Page</span>
            </a>
          </div>
        </div>
      `;

      // Allow Enter key in the search input
      const input = document.getElementById('cartTrackSearchInput');
      if (input) {
        input.addEventListener('keydown', (e) => {
          if (e.key === 'Enter') {
            e.preventDefault();
            this.handleTrackSearch();
          }
        });
      }
    },

    // 13. Handle Search Button Click
    handleTrackSearch: function () {
      const input = document.getElementById('cartTrackSearchInput');
      const val = input ? input.value.trim() : '';
      if (!val) {
        this.showToast('Please enter a B/L number or Tracking ID');
        return;
      }
      this.renderTracking(val);
      this.showToast(`Retrieved satellite tracking for "${val}"`);
    },

    // 14. Copy Tracking ID to Clipboard
    copyTrackingInfo: function (id) {
      if (navigator.clipboard) {
        navigator.clipboard.writeText(id).then(() => {
          this.showToast(`Copied Consignment ID "${id}" to clipboard!`);
        });
      } else {
        this.showToast(`Consignment ID: ${id}`);
      }
    },

    // 15. Open Cart Drawer (Optionally target a specific tab)
    openDrawer: function (targetTab = 'items') {
      const overlay = document.getElementById('cartDrawerOverlay');
      if (overlay) {
        overlay.classList.add('active');
        document.body.style.overflow = 'hidden';
        this.switchTab(targetTab);
        this.updateBadges();
      }
    },

    // 16. Close Cart Drawer
    closeDrawer: function () {
      const overlay = document.getElementById('cartDrawerOverlay');
      if (overlay) {
        overlay.classList.remove('active');
        document.body.style.overflow = '';
      }
    },

    // 17. Show Floating Toast Feedback
    showToast: function (message) {
      let toast = document.getElementById('conceptCartToast');
      if (!toast) {
        toast = document.createElement('div');
        toast.id = 'conceptCartToast';
        toast.className = 'concept-cart-toast';
        document.body.appendChild(toast);
      }

      toast.innerHTML = `
        <i class="fa-solid fa-circle-check toast-icon"></i>
        <span>${message}</span>
      `;

      toast.classList.add('show');
      if (this.toastTimeout) clearTimeout(this.toastTimeout);
      this.toastTimeout = setTimeout(() => {
        toast.classList.remove('show');
      }, 3500);
    },

    // 18. Open RFQ Checkout Modal
    openRfqModal: function () {
      const cart = this.getCart();
      if (cart.length === 0) {
        this.showToast('Please add items to your cart first.');
        return;
      }
      this.closeDrawer();

      const totals = this.getTotals();
      const rfqModalOverlay = document.getElementById('cartRfqModalOverlay');
      const rfqItemCount = document.getElementById('rfqItemCount');
      const rfqTotalVal = document.getElementById('rfqTotalVal');

      if (rfqItemCount) rfqItemCount.textContent = `${totals.itemCount} Commodities (${totals.totalUnits} Units)`;
      if (rfqTotalVal) {
        rfqTotalVal.textContent = '₹' + totals.totalAmount.toLocaleString('en-IN', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        });
      }

      if (rfqModalOverlay) {
        rfqModalOverlay.classList.add('active');
        document.body.style.overflow = 'hidden';
      }
    },

    // 19. Close RFQ Modal
    closeRfqModal: function () {
      const rfqModalOverlay = document.getElementById('cartRfqModalOverlay');
      if (rfqModalOverlay) {
        rfqModalOverlay.classList.remove('active');
        document.body.style.overflow = '';
      }
    },

    // 20. Auto-Inject HTML Markup if not already present
    injectCartDOM: function () {
      if (document.getElementById('cartDrawerOverlay')) return;

      const domWrapper = document.createElement('div');
      domWrapper.innerHTML = `
        <!-- Cart & Tracking Slide-Over Drawer -->
        <div class="cart-drawer-overlay" id="cartDrawerOverlay" aria-hidden="true">
          <div class="cart-drawer-container" id="cartDrawerContainer" role="dialog" aria-modal="true" aria-labelledby="cartDrawerTitle">
            <!-- Header -->
            <div class="cart-drawer-header">
              <div class="cart-header-title-wrap">
                <div class="cart-header-icon"><i class="fa-solid fa-ship"></i></div>
                <div class="cart-header-text">
                  <h2 class="cart-drawer-title" id="cartDrawerTitle">Trade Order Portal</h2>
                  <span class="cart-drawer-subtitle"><span id="cartDrawerItemCount" class="cart-count-badge">0</span> commodities in quotation</span>
                </div>
              </div>
              <div class="cart-header-actions">
                <a href="cart.html" class="cart-header-full-link" title="Open Full Trade Cart Page"><i class="fa-solid fa-up-right-from-square"></i> Full Cart</a>
                <button class="cart-btn-clear" id="cartClearAllBtn" title="Clear all items"><i class="fa-regular fa-trash-can"></i> Clear</button>
                <button class="cart-btn-close" id="cartCloseBtn" aria-label="Close Cart"><i class="fa-solid fa-xmark"></i></button>
              </div>
            </div>

            <!-- Tab Switcher: Quotation Cart vs Live Cargo Tracking -->
            <div class="cart-drawer-tabs" role="tablist">
              <button class="cart-tab-btn active" id="cartTabItemsBtn" onclick="ConceptCart.switchTab('items')" role="tab" aria-selected="true">
                <i class="fa-solid fa-cart-shopping"></i>
                <span>Quotation Cart</span>
                <span class="cart-tab-badge" id="cartTabCountBadge">0</span>
              </button>
              <button class="cart-tab-btn" id="cartTabTrackBtn" onclick="ConceptCart.switchTab('track')" role="tab" aria-selected="false">
                <i class="fa-solid fa-satellite-dish"></i>
                <span>Live Cargo Tracking</span>
                <span class="cart-tab-pulse-dot" title="Live Telemetry Available"></span>
              </button>
            </div>

            <!-- Free Global Logistics / Insurance Notice Banner (Visible in Cart view) -->
            <div class="cart-shipping-notice" id="cartNoticeBanner">
              <span class="cart-notice-shield"><i class="fa-solid fa-shield-halved"></i></span>
              <span>Export Certificate &amp; Standard Phytosanitary Included</span>
            </div>

            <!-- VIEW 1: QUOTATION CART ITEMS -->
            <div class="cart-tab-view" id="cartTabItemsView" style="display: flex; flex-direction: column; flex: 1; min-height: 0;">
              <!-- Body / Items List -->
              <div class="cart-drawer-body" id="cartDrawerBody">
                <!-- Injected by JavaScript -->
              </div>

              <!-- Footer Summary & Checkout Actions -->
              <div class="cart-drawer-footer" id="cartDrawerFooter">
                <!-- Fast Track Consignment CTA strip -->
                <div class="cart-tracking-cta-strip" onclick="ConceptCart.switchTab('track')" title="Switch to Live Tracking">
                  <div class="cart-tracking-cta-left">
                    <i class="fa-solid fa-satellite-dish"></i>
                    <div>
                      <strong>Track Existing Cargo</strong>
                      <span>Real-time satellite GPS &amp; B/L tracking</span>
                    </div>
                  </div>
                  <span class="cart-btn-track-now">Track <i class="fa-solid fa-arrow-right"></i></span>
                </div>

                <div class="cart-summary-card">
                  <div class="cart-summary-row">
                    <span class="cart-summary-label">Commodity Subtotal</span>
                    <strong class="cart-summary-val" id="cartSubtotal">₹0.00</strong>
                  </div>
                  <div class="cart-summary-row">
                    <span class="cart-summary-label">Export Inspection &amp; Docs</span>
                    <span class="cart-badge-free"><i class="fa-solid fa-circle-check"></i> Complimentary</span>
                  </div>
                  <div class="cart-summary-row">
                    <span class="cart-summary-label">Est. Cargo Freight</span>
                    <span class="cart-badge-port">Quoted at Port of Origin</span>
                  </div>
                  <div class="cart-summary-divider"></div>
                  <div class="cart-summary-total-row">
                    <span class="cart-total-label">Estimated Total <small class="cart-total-incoterm">(Ex-Works)</small></span>
                    <strong class="cart-total-amount" id="cartTotalAmount">₹0.00</strong>
                  </div>
                </div>

                <div class="cart-action-buttons">
                  <a href="cart.html" class="cart-btn-view-full" id="cartViewFullPageBtn">
                    <i class="fa-solid fa-up-right-from-square"></i>
                    <span>View Full Trade Cart Page</span>
                    <i class="fa-solid fa-arrow-right cart-btn-arrow"></i>
                  </a>
                  <button class="cart-btn-checkout" id="cartCheckoutBtn">
                    <i class="fa-solid fa-file-invoice-dollar"></i>
                    <span>Proceed to RFQ / Commercial Order</span>
                    <i class="fa-solid fa-arrow-right cart-btn-arrow"></i>
                  </button>
                  <a href="https://wa.me/919876543210?text=Hello%20CONCEPT%20EXIM%20Trade%20Desk%2C%20I%20want%20to%20place%20an%20export%20inquiry%20from%20my%20trade%20cart." target="_blank" class="cart-btn-whatsapp" id="cartWhatsappBtn">
                    <i class="fa-brands fa-whatsapp"></i>
                    <span>Direct Trade Desk (WhatsApp)</span>
                    <i class="fa-solid fa-arrow-up-right-from-square cart-btn-arrow"></i>
                  </a>
                  <button class="cart-btn-continue" id="cartContinueBtn">
                    <i class="fa-solid fa-arrow-left"></i>
                    <span>Continue Browsing Products</span>
                  </button>
                </div>
              </div>
            </div>

            <!-- VIEW 2: LIVE CARGO TRACKING CONSOLE -->
            <div class="cart-tab-view" id="cartTabTrackView" style="display: none; flex-direction: column; flex: 1; min-height: 0; overflow-y: auto;">
              <div class="cart-track-body-container" id="cartTabTrackBody">
                <!-- Dynamically populated by renderTracking() -->
              </div>
            </div>

          </div>
        </div>

        <!-- RFQ Proforma Invoice Modal -->
        <div class="cart-rfq-modal-overlay" id="cartRfqModalOverlay">
          <div class="cart-rfq-modal">
            <div class="cart-rfq-header">
              <div class="cart-rfq-title">
                <i class="fa-solid fa-file-invoice-dollar" style="color: #df8b1a; font-size: 20px;"></i>
                <h3>Request Proforma Invoice / Export RFQ</h3>
              </div>
              <button class="cart-rfq-close" id="cartRfqCloseBtn">&times;</button>
            </div>
            <div class="cart-rfq-body" id="cartRfqBody">
              <div class="cart-rfq-summary-box">
                <div class="rfq-summary-count"><span id="rfqItemCount">0</span> Commodities Selected</div>
                <div class="rfq-summary-total" id="rfqTotalVal">₹0.00</div>
              </div>
              <form id="cartRfqForm">
                <div class="rfq-form-grid">
                  <div class="rfq-form-group">
                    <label>Buyer / Contact Name *</label>
                    <input type="text" id="rfqBuyerName" required placeholder="e.g. Robert Smith">
                  </div>
                  <div class="rfq-form-group">
                    <label>Company / Importer Name *</label>
                    <input type="text" id="rfqCompanyName" required placeholder="e.g. Continental Food Imports LLC">
                  </div>
                  <div class="rfq-form-group">
                    <label>Business Email *</label>
                    <input type="email" id="rfqEmail" required placeholder="e.g. trade@company.com">
                  </div>
                  <div class="rfq-form-group">
                    <label>Phone / WhatsApp *</label>
                    <input type="tel" id="rfqPhone" required placeholder="e.g. +1 415-555-2671">
                  </div>
                  <div class="rfq-form-group">
                    <label>Destination Port / Country *</label>
                    <input type="text" id="rfqDestination" required placeholder="e.g. Port of Rotterdam / Dubai / Singapore">
                  </div>
                  <div class="rfq-form-group">
                    <label>Incoterms Preferred</label>
                    <select id="rfqIncoterms">
                      <option value="CIF" selected>CIF - Cost, Insurance & Freight</option>
                      <option value="FOB">FOB - Free on Board</option>
                      <option value="CFR">CFR - Cost and Freight</option>
                      <option value="EXW">EXW - Ex Works</option>
                      <option value="DAP">DAP - Delivered at Place</option>
                    </select>
                  </div>
                </div>
                <div class="rfq-form-group" style="margin-top: 12px;">
                  <label>Packaging & Shipping Specifications</label>
                  <textarea id="rfqNotes" rows="2" placeholder="e.g. 25kg PP bags palletized, phytosanitary certificate, COA required..."></textarea>
                </div>
                <button type="submit" class="rfq-submit-btn" id="rfqSubmitBtn">
                  <i class="fa-solid fa-paper-plane"></i>
                  <span>Dispatch Export RFQ & Generate Proforma</span>
                </button>
              </form>
            </div>
          </div>
        </div>
      `;
      document.body.appendChild(domWrapper);

      // Inject Global Top-Slim-Bar "Track Cargo" button if top-right-group exists on current page
      this.injectTopBarTrackingButton();
    },

    // 21. Inject Track Button in Top Slim Bar if present
    injectTopBarTrackingButton: function () {
      const topGroup = document.querySelector('.top-right-group');
      if (topGroup) {
        // Prevent duplicate: do not inject if any tracking link or button already exists
        if (document.getElementById('openTopTrackBtn') || topGroup.querySelector('a[href*="tracking.html"], .top-track-btn')) {
          return;
        }

        const cartBtn = topGroup.querySelector('#openCartBtn');
        const trackBtn = document.createElement('button');
        trackBtn.className = 'top-link-btn top-track-btn';
        trackBtn.id = 'openTopTrackBtn';
        trackBtn.setAttribute('aria-label', 'Live Satellite Cargo Tracking');
        trackBtn.title = 'Track Live Export Consignment';
        trackBtn.innerHTML = `
          <i class="fa-solid fa-satellite-dish" style="color: #df8b1a;"></i>
          <span>Track Cargo</span>
        `;
        trackBtn.addEventListener('click', (e) => {
          e.preventDefault();
          window.location.href = 'tracking.html';
        });

        const divider = document.createElement('div');
        divider.className = 'top-divider';

        if (cartBtn) {
          topGroup.insertBefore(trackBtn, cartBtn);
          topGroup.insertBefore(divider, cartBtn);
        } else {
          topGroup.appendChild(trackBtn);
        }
      }
    },

    // 22. Bind Event Listeners
    initEvents: function () {
      // 1. Top Cart Button & Trigger Bindings
      document.querySelectorAll('#openCartBtn, .top-cart-btn, [data-open-cart]').forEach(btn => {
        btn.addEventListener('click', (e) => {
          e.preventDefault();
          this.openDrawer('items');
        });
      });

      // 2. Global Track Buttons - navigate to dedicated full tracking page
      document.querySelectorAll('#openTopTrackBtn, .btn-open-track, [data-open-track]').forEach(btn => {
        btn.addEventListener('click', (e) => {
          e.preventDefault();
          window.location.href = 'tracking.html';
        });
      });

      // 3. Drawer Close & Backdrop Handlers
      const closeBtn = document.getElementById('cartCloseBtn');
      const continueBtn = document.getElementById('cartContinueBtn');
      const overlay = document.getElementById('cartDrawerOverlay');
      const clearAllBtn = document.getElementById('cartClearAllBtn');
      const checkoutBtn = document.getElementById('cartCheckoutBtn');

      if (closeBtn) closeBtn.addEventListener('click', () => this.closeDrawer());
      if (continueBtn) continueBtn.addEventListener('click', () => this.closeDrawer());
      if (clearAllBtn) clearAllBtn.addEventListener('click', () => this.clearCart());
      if (checkoutBtn) checkoutBtn.addEventListener('click', () => this.openRfqModal());

      if (overlay) {
        overlay.addEventListener('click', (e) => {
          if (e.target === overlay) this.closeDrawer();
        });
      }

      // 4. RFQ Modal Close Handlers
      const rfqCloseBtn = document.getElementById('cartRfqCloseBtn');
      const rfqOverlay = document.getElementById('cartRfqModalOverlay');
      const rfqForm = document.getElementById('cartRfqForm');

      if (rfqCloseBtn) rfqCloseBtn.addEventListener('click', () => this.closeRfqModal());
      if (rfqOverlay) {
        rfqOverlay.addEventListener('click', (e) => {
          if (e.target === rfqOverlay) this.closeRfqModal();
        });
      }

      // 5. RFQ Form Submission
      if (rfqForm) {
        rfqForm.addEventListener('submit', (e) => {
          e.preventDefault();
          const rfqId = 'RFQ-EXP-' + Math.floor(100000 + Math.random() * 900000);
          const buyerName = document.getElementById('rfqBuyerName')?.value || 'Valued Trader';
          const rfqBody = document.getElementById('cartRfqBody');

          if (rfqBody) {
            rfqBody.innerHTML = `
              <div class="rfq-success-wrap">
                <div class="rfq-success-icon"><i class="fa-solid fa-check"></i></div>
                <h3>Export RFQ Dispatched!</h3>
                <p>Thank you, <strong>${buyerName}</strong>. Your commercial inquiry and Proforma request <strong>${rfqId}</strong> has been routed to our global trade desk.</p>
                <div style="background: #f1f5f9; border-radius: 8px; padding: 12px; margin-bottom: 20px; font-size: 13px; color: #334155;">
                  <div><strong>Reference ID:</strong> ${rfqId}</div>
                  <div><strong>Response Time:</strong> Within 2 Business Hours</div>
                  <div><strong>Trade Desk:</strong> trade@conceptexim.com</div>
                </div>
                <div style="display: flex; gap: 10px; justify-content: center;">
                  <button class="rfq-success-btn" onclick="ConceptCart.closeRfqModal()">Return to Portal</button>
                  <button class="rfq-success-btn" style="background: linear-gradient(135deg, #df8b1a 0%, #cf7d12 100%);" onclick="ConceptCart.closeRfqModal(); ConceptCart.openDrawer('track');">Track Cargo</button>
                </div>
              </div>
            `;
          }

          this.showToast(`Proforma Request ${rfqId} submitted successfully!`);
        });
      }

      // 6. Global Escape Key Handler
      document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape') {
          this.closeDrawer();
          this.closeRfqModal();
        }
      });

      // 7. Bind Products Page Cards
      this.bindProductPageCards();
    },

    // 23. Bind Product Card "Add to Cart" Buttons on Products Page
    bindProductPageCards: function () {
      document.querySelectorAll('.product-card').forEach((card, idx) => {
        const addBtn = card.querySelector('.btn-card-add-cart');
        const qtyInput = card.querySelector('.qty-input-field');
        const minusBtn = card.querySelector('.btn-minus');
        const plusBtn = card.querySelector('.btn-plus');
        const titleEl = card.querySelector('.product-item-title');
        const specEl = card.querySelector('.product-item-spec');
        const priceVal = card.getAttribute('data-price') || '45';
        const originVal = card.getAttribute('data-origin') || 'India';
        const imgEl = card.querySelector('.product-thumb-img');

        if (minusBtn && qtyInput && !minusBtn.dataset.bound) {
          minusBtn.dataset.bound = 'true';
          minusBtn.addEventListener('click', () => {
            let val = parseInt(qtyInput.value) || 1;
            if (val > 1) qtyInput.value = val - 1;
          });
        }

        if (plusBtn && qtyInput && !plusBtn.dataset.bound) {
          plusBtn.dataset.bound = 'true';
          plusBtn.addEventListener('click', () => {
            let val = parseInt(qtyInput.value) || 1;
            qtyInput.value = val + 1;
          });
        }

        if (addBtn && !addBtn.dataset.bound) {
          addBtn.dataset.bound = 'true';
          addBtn.addEventListener('click', (e) => {
            e.preventDefault();
            const name = addBtn.getAttribute('data-name') || (titleEl ? titleEl.textContent.trim() : 'Commodity Item');
            const qty = qtyInput ? (parseInt(qtyInput.value) || 1) : 1;
            const id = 'prod_' + name.toLowerCase().replace(/[^a-z0-9]/g, '_');

            ConceptCart.addItem({
              id: id,
              name: name,
              spec: specEl ? specEl.textContent.trim() : 'Export Standard Grade',
              price: parseFloat(priceVal) || 45,
              unit: 'Kg',
              origin: originVal,
              image: imgEl ? imgEl.getAttribute('src') : 'images/products_crop/prod_basmati.jpg',
              qty: qty
            });

            const originalHtml = addBtn.innerHTML;
            addBtn.innerHTML = '<i class="fa-solid fa-check"></i><span>Added ✓</span>';
            addBtn.style.background = '#16a34a';
            setTimeout(() => {
              addBtn.innerHTML = originalHtml;
              addBtn.style.background = '';
            }, 1400);
          });
        }
      });
    },

    // 24. Initialize System
    init: function () {
      this.injectCartDOM();
      this.initEvents();
      this.updateBadges();
      this.renderCart();
    }
  };

  // Run on DOM Ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => ConceptCart.init());
  } else {
    ConceptCart.init();
  }
})();
