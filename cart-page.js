/**
 * CONCEPT EXIM - Full Trade Cart Page Controller
 * Handles table rendering, real-time Incoterms freight calculations,
 * quantity adjustments, proforma generation, and synchronization with ConceptCart.
 */

(function () {
  'use strict';

  // Port routes and transit estimates database
  const SHIPPING_ROUTES = {
    'UAE': {
      port: 'Jebel Ali Port (AEJEA)',
      transit: '4 – 7 Days (Direct Persian Gulf Corridor)',
      freightPerTon: 2200,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'USA': {
      port: 'Port of New York / New Jersey (USNYC)',
      transit: '22 – 28 Days (Atlantic Ocean Line)',
      freightPerTon: 6800,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'Germany': {
      port: 'Port of Hamburg (DEHAM)',
      transit: '18 – 22 Days (Suez / North Sea Route)',
      freightPerTon: 5200,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'Netherlands': {
      port: 'Port of Rotterdam (NLRTM)',
      transit: '17 – 21 Days (Euro Gateway)',
      freightPerTon: 5000,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'Saudi Arabia': {
      port: 'Jeddah Islamic Port (SAJED)',
      transit: '6 – 9 Days (Red Sea Passage)',
      freightPerTon: 2600,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'Singapore': {
      port: 'Port of Singapore (SGSIN)',
      transit: '7 – 10 Days (Malacca Strait Corridor)',
      freightPerTon: 2900,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'UK': {
      port: 'Port of Felixstowe (GBFXT)',
      transit: '20 – 24 Days (UK Deep Sea Gateway)',
      freightPerTon: 5400,
      mode: 'Ocean Container (FCL / LCL)'
    },
    'Canada': {
      port: 'Port of Montreal (CAMTR)',
      transit: '24 – 29 Days (St. Lawrence Seaway)',
      freightPerTon: 7200,
      mode: 'Ocean Container (FCL / LCL)'
    }
  };

  window.ConceptFullCart = {
    selectedIncoterm: 'FOB',
    selectedCountry: 'UAE',
    selectedCurrency: 'INR',
    currencyRates: {
      'INR': { symbol: '₹', rate: 1 },
      'USD': { symbol: '$', rate: 0.012 },
      'EUR': { symbol: '€', rate: 0.011 },
      'AED': { symbol: 'AED ', rate: 0.044 }
    },

    // 1. Initialize
    init: function () {
      this.bindEvents();
      this.renderFullCart();
    },

    // 2. Format Price with Currency
    formatPrice: function (amountInINR) {
      const cur = this.currencyRates[this.selectedCurrency] || this.currencyRates['INR'];
      const converted = amountInINR * cur.rate;
      return cur.symbol + converted.toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      });
    },

    // 3. Render Full Cart Items
    renderFullCart: function () {
      if (!window.ConceptCart) return;

      const cart = window.ConceptCart.getCart();
      const tbody = document.getElementById('cartItemsList');
      const tableCard = document.getElementById('cartTableCard');
      const emptyState = document.getElementById('cartEmptyState');
      const fullCountEl = document.getElementById('cartFullItemCount');
      const heroStatItemsEl = document.getElementById('heroStatItems');
      const heroStatWeightEl = document.getElementById('heroStatWeight');

      // Update counters
      const totalUnits = cart.reduce((sum, item) => sum + (parseInt(item.qty) || 1), 0);
      if (fullCountEl) fullCountEl.textContent = cart.length;
      if (heroStatItemsEl) heroStatItemsEl.textContent = `${cart.length} Commodities`;
      if (heroStatWeightEl) heroStatWeightEl.textContent = `${(totalUnits * 0.025).toFixed(1)} MT Est.`;
      const navCartBadge = document.getElementById('navCartCountBadge');
      if (navCartBadge) navCartBadge.textContent = cart.length;

      // Handle Empty State
      if (cart.length === 0) {
        if (tableCard) tableCard.style.display = 'none';
        if (emptyState) emptyState.style.display = 'flex';
        this.updateSummary(0);
        return;
      }

      if (tableCard) tableCard.style.display = 'block';
      if (emptyState) emptyState.style.display = 'none';

      if (!tbody) return;
      tbody.innerHTML = '';

      let subtotal = 0;

      cart.forEach((item, index) => {
        const itemPrice = parseFloat(item.price) || 0;
        const itemQty = parseInt(item.qty) || 1;
        const lineTotal = itemPrice * itemQty;
        subtotal += lineTotal;

        const row = document.createElement('div');
        row.className = 'cart-item-row';
        row.innerHTML = `
          <!-- 1. Product Info -->
          <div class="cart-prod-cell">
            <a href="products.html" class="cart-prod-thumb-link" title="View Product Details">
              <img src="${item.image || 'images/products_crop/prod_basmati.jpg'}" alt="${item.name}" class="cart-prod-thumb-img">
            </a>
            <div class="cart-prod-details">
              <a href="products.html" class="cart-prod-name">${item.name}</a>
              <span class="cart-prod-spec">${item.spec || 'International Export Grade Standard'}</span>
              <div class="cart-prod-tags">
                <span class="cart-origin-tag"><span>🌐</span> Origin: ${item.origin || 'India'}</span>
                <span class="cart-pkg-badge">Export Packaging</span>
              </div>
            </div>
          </div>

          <!-- 2. Unit Price -->
          <div class="cart-price-cell">
            <span class="cart-unit-price">${this.formatPrice(itemPrice)}</span>
            <span class="cart-unit-label">per ${item.unit || 'Kg'}</span>
          </div>

          <!-- 3. Quantity Stepper -->
          <div class="cart-qty-cell">
            <div class="cart-page-stepper">
              <button type="button" class="cart-page-step-btn btn-minus" data-id="${item.id}" aria-label="Decrease quantity">−</button>
              <input type="number" class="cart-page-step-input" data-id="${item.id}" value="${itemQty}" min="1" max="100000">
              <button type="button" class="cart-page-step-btn btn-plus" data-id="${item.id}" aria-label="Increase quantity">+</button>
            </div>
          </div>

          <!-- 4. Line Subtotal -->
          <div class="cart-subtotal-cell">
            <strong class="cart-item-subtotal">${this.formatPrice(lineTotal)}</strong>
            <span class="cart-subtotal-cur">${itemQty} × ${this.formatPrice(itemPrice)}</span>
          </div>

          <!-- 5. Delete Action -->
          <div class="cart-delete-cell">
            <button type="button" class="cart-btn-row-del" data-id="${item.id}" title="Remove commodity from cart" aria-label="Remove item">
              <i class="fa-regular fa-trash-can"></i>
            </button>
          </div>
        `;

        tbody.appendChild(row);
      });

      // Bind Row Buttons
      this.bindRowEvents(tbody);
      this.updateSummary(subtotal);
    },

    // 4. Bind Stepper & Delete Events in Rows
    bindRowEvents: function (container) {
      // Minus buttons
      container.querySelectorAll('.btn-minus').forEach(btn => {
        btn.addEventListener('click', () => {
          const id = btn.getAttribute('data-id');
          if (window.ConceptCart) {
            window.ConceptCart.updateQty(id, -1);
            this.renderFullCart();
          }
        });
      });

      // Plus buttons
      container.querySelectorAll('.btn-plus').forEach(btn => {
        btn.addEventListener('click', () => {
          const id = btn.getAttribute('data-id');
          if (window.ConceptCart) {
            window.ConceptCart.updateQty(id, 1);
            this.renderFullCart();
          }
        });
      });

      // Direct Input
      container.querySelectorAll('.cart-page-step-input').forEach(input => {
        input.addEventListener('change', () => {
          const id = input.getAttribute('data-id');
          const val = parseInt(input.value) || 1;
          if (window.ConceptCart) {
            window.ConceptCart.updateQty(id, val, true);
            this.renderFullCart();
          }
        });
      });

      // Delete buttons
      container.querySelectorAll('.cart-btn-row-del').forEach(btn => {
        btn.addEventListener('click', () => {
          const id = btn.getAttribute('data-id');
          if (window.ConceptCart) {
            window.ConceptCart.removeItem(id);
            this.renderFullCart();
          }
        });
      });
    },

    // 5. Update Summary & Commercial Calculation Breakdown
    updateSummary: function (subtotal) {
      const subtotalEl = document.getElementById('sumCommoditySubtotal');
      const freightValEl = document.getElementById('sumFreightVal');
      const grandTotalEl = document.getElementById('sumGrandTotal');
      const incotermBadgeEl = document.getElementById('sumIncotermBadge');
      const heroStatSubtotalEl = document.getElementById('heroStatSubtotal');

      const routeInfo = SHIPPING_ROUTES[this.selectedCountry] || SHIPPING_ROUTES['UAE'];

      // Freight calculation based on Incoterm
      let freightCost = 0;
      if (this.selectedIncoterm === 'CIF' || this.selectedIncoterm === 'CFR' || this.selectedIncoterm === 'DAP') {
        const cart = window.ConceptCart ? window.ConceptCart.getCart() : [];
        const totalUnits = cart.reduce((sum, item) => sum + (parseInt(item.qty) || 1), 0);
        // Estimate approx metric tons
        const estTons = Math.max(0.5, totalUnits * 0.025);
        freightCost = estTons * routeInfo.freightPerTon;
      }

      const grandTotal = subtotal + freightCost;

      if (subtotalEl) subtotalEl.textContent = this.formatPrice(subtotal);
      if (heroStatSubtotalEl) heroStatSubtotalEl.textContent = this.formatPrice(subtotal);

      if (freightValEl) {
        if (freightCost === 0) {
          freightValEl.innerHTML = `<span style="color: #64748b; font-size: 11.5px;">Quoted at Port of Origin (${this.selectedIncoterm})</span>`;
        } else {
          freightValEl.textContent = this.formatPrice(freightCost);
        }
      }

      if (grandTotalEl) grandTotalEl.textContent = this.formatPrice(grandTotal);
      if (incotermBadgeEl) incotermBadgeEl.textContent = `(${this.selectedIncoterm} Basis)`;

      // Update WhatsApp link text with live values
      const whatsappBtn = document.getElementById('btnCartWhatsapp');
      if (whatsappBtn) {
        const text = encodeURIComponent(
          `Hello CONCEPT EXIM Trade Desk, I would like to place an export inquiry for my quotation (Incoterm: ${this.selectedIncoterm}, Destination: ${routeInfo.port}, Estimated Subtotal: ${this.formatPrice(subtotal)}). Reference: RFQ-EXP-${Math.floor(100000 + Math.random() * 900000)}.`
        );
        whatsappBtn.href = `https://wa.me/919876543210?text=${text}`;
      }
    },

    // 6. Bind Page Controls (Incoterms, Shipping Selectors, Actions)
    bindEvents: function () {
      // Clear All Cart Button
      const clearBtn = document.getElementById('btnClearFullCart');
      if (clearBtn) {
        clearBtn.addEventListener('click', () => {
          if (window.ConceptCart) {
            window.ConceptCart.clearCart();
            this.renderFullCart();
          }
        });
      }

      // Incoterm Option Boxes
      document.querySelectorAll('.incoterm-option-box').forEach(box => {
        box.addEventListener('click', () => {
          document.querySelectorAll('.incoterm-option-box').forEach(b => b.classList.remove('active'));
          box.classList.add('active');
          this.selectedIncoterm = box.getAttribute('data-incoterm') || 'FOB';
          
          const totals = window.ConceptCart ? window.ConceptCart.getTotals() : { totalAmount: 0 };
          this.updateSummary(totals.totalAmount);
        });
      });

      // Destination Country Selector
      const countrySelect = document.getElementById('destCountrySelect');
      const portNameEl = document.getElementById('destPortName');
      const transitTimeEl = document.getElementById('destTransitTime');

      if (countrySelect) {
        countrySelect.addEventListener('change', () => {
          this.selectedCountry = countrySelect.value;
          const info = SHIPPING_ROUTES[this.selectedCountry] || SHIPPING_ROUTES['UAE'];
          if (portNameEl) portNameEl.textContent = info.port;
          if (transitTimeEl) transitTimeEl.textContent = info.transit;

          const totals = window.ConceptCart ? window.ConceptCart.getTotals() : { totalAmount: 0 };
          this.updateSummary(totals.totalAmount);
        });
      }

      // Currency Switcher
      const currencySelect = document.getElementById('cartCurrencySelect');
      if (currencySelect) {
        currencySelect.addEventListener('change', () => {
          this.selectedCurrency = currencySelect.value;
          this.renderFullCart();
        });
      }

      // Checkout / RFQ Modal Launcher
      const checkoutBtn = document.getElementById('btnCartCheckout');
      if (checkoutBtn) {
        checkoutBtn.addEventListener('click', () => {
          if (window.ConceptCart) {
            window.ConceptCart.openRfqModal();
          }
        });
      }

      // Print / PDF Proforma Invoice
      const printBtn = document.getElementById('btnCartPrintProforma');
      if (printBtn) {
        printBtn.addEventListener('click', () => {
          window.print();
        });
      }
    },

    // 7. Quick-Add Sample Items if Cart is Empty
    quickAddSample: function (name, price, image, origin) {
      if (!window.ConceptCart) return;
      window.ConceptCart.addItem({
        id: 'prod_' + name.toLowerCase().replace(/[^a-z0-9]/g, '_'),
        name: name,
        spec: 'International Export Grade Standards',
        price: price,
        unit: 'Kg',
        origin: origin,
        image: image,
        qty: 25
      });
      this.renderFullCart();
    }
  };

  // Run on DOM Ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => ConceptFullCart.init());
  } else {
    ConceptFullCart.init();
  }
})();
