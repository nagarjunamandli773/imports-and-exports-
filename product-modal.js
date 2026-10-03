/**
 * CONCEPT EXIM - Interactive Product Details Modal & Quick View Engine
 * Displays comprehensive commercial export specifications, live pricing calculations,
 * logistics data, and integrated trade cart / RFQ actions.
 */

(function () {
  'use strict';

  // Comprehensive B2B Export Commodity Database
  const PRODUCT_SPECS_DB = {
    'black pepper': {
      spec: 'Pure & Natural • Grade 550GL Malabar Garbled',
      moq: '500 Kg (Sample lot: 25 Kg)',
      packaging: '25 / 50 Kg Multiwall Vacuum HDPE Bags with Nitrogen Flush',
      moisture: '< 11.5% Max Standard',
      shelfLife: '24 Months in Cool, Dry Ventilated Storage',
      leadTime: '3 – 5 Business Days Post Quality Clearance',
      ports: 'Mundra Port (INMUN1), Cochin Port (INCOK1)',
      description: 'Harvested from the fertile high ranges of Malabar and Wayanad, our Tellicherry and Malabar Black Pepper is processed with sortex grading to achieve a high bulk density (550GL to 570GL). Machine-cleaned, steam-sterilized, and lab-certified for high piperine concentration (>5.5%), bold pungent aroma, and zero extraneous foreign matter. Trusted by spice processors, culinary packagers, and oleoresin extractors worldwide.',
      payload: '16 – 18 Metric Tons in 1 × 20ft FCL (Palletized)'
    },
    'almonds': {
      spec: 'Premium Nonpareil Grade • Size 27/30 & 25/27 Count',
      moq: '500 Kg (Sample: 25 Kg)',
      packaging: '11.34 Kg (25 lbs) or 22.68 Kg (50 lbs) Food-Grade Corrugated Cartons with Poly-Liner',
      moisture: '< 6.0% Max Standard',
      shelfLife: '18 Months under Controlled Temperature (10°C - 15°C)',
      leadTime: '4 – 7 Business Days',
      ports: 'Port of Oakland (USA), Mundra Port (India)',
      description: 'Top-grade California Nonpareil Almonds, prized for their smooth, attractive golden skin, uniform sizing, and sweet nutty flavor. Mechanically hulled, laser-sorted for zero mechanical chipped kernels, and certified under strict USDA No. 1 specifications and EU aflatoxin limits. Ideal for confectionery, direct snacking, and almond milk extraction.',
      payload: '20 Metric Tons in 1 × 40ft High Cube Container'
    },
    'california walnuts': {
      spec: 'Extra Light & Light Halves (80%+ Halves Ratio)',
      moq: '250 Kg (Sample: 20 Kg)',
      packaging: '10 Kg / 25 lbs Nitrogen-Flushed Vacuum Export Cartons',
      moisture: '< 4.5% Critical Max',
      shelfLife: '12 Months in Cool Storage (Refrigerated)',
      leadTime: '3 – 5 Days Dispatch',
      ports: 'Port of Los Angeles / Long Beach, Mundra Port',
      description: 'Specially selected California English Walnuts (Chandler & Hartley varieties), mechanically cracked and optical-sorted into pristine Extra Light Halves. Packed with natural plant Omega-3 ALA (Alpha-Linolenic Acid) and potent antioxidants. Nitrogen-flushed at source to preserve enzymatic integrity and prevent lipid oxidation.',
      payload: '18 Metric Tons per 40ft HC Reefer Container'
    },
    'cashew nuts': {
      spec: 'Whole White Kernels • Grade W240 Jumbo & W320 Standard',
      moq: '500 Kg',
      packaging: '2 × 10 Kg Vacuum-Sealed Nitrogen/CO2 Flushing Tins or Flexible Pouches',
      moisture: '< 5.0% Max',
      shelfLife: '24 Months in Sealed Vacuum Conditions',
      leadTime: '3 – 6 Business Days',
      ports: 'Ho Chi Minh City Port (Vietnam), JNPT Mumbai (India)',
      description: 'Export-grade Whole White Cashews meeting AFI (Association of Food Industries) grade guidelines. Characterized by uniform ivory-white color, sweet nutty crunch, and completely free from insect damage or speckling. Carefully roasted and packed in modified atmospheric packaging for long international ocean transit.',
      payload: '16 Metric Tons in 1 × 20ft FCL'
    },
    'masoor dal': {
      spec: 'Red Split Lentils • High Protein Sortex Cleaned',
      moq: '1,000 Kg (1 Metric Ton)',
      packaging: '25 Kg / 50 Kg High-Density Polypropylene (PP) Woven Sacks',
      moisture: '< 12.0% Max',
      shelfLife: '24 Months in Dry Ambient Storage',
      leadTime: '3 – 5 Business Days',
      ports: 'Port of Vancouver (Canada), Mundra Port (India)',
      description: 'Premium split red lentils (Lens culinaris), dehusked and machine-polished without any synthetic oils or color additives. Offers rapid boiling time, vibrant reddish-orange coloration, and over 24% bio-available plant protein. Rigorously tested for minimum foreign matter (<0.2%) and uniform grain caliber.',
      payload: '24 – 26 Metric Tons in 1 × 20ft FCL'
    },
    'dried apricots': {
      spec: 'Malatya Whole Sun-Dried • Jumbo Size 1 & 2',
      moq: '300 Kg',
      packaging: '5 Kg & 12.5 Kg Heavy-Duty Telescopic Master Cartons',
      moisture: '22% – 24% Natural Retention',
      shelfLife: '18 Months in Dry Ambient Warehouse',
      leadTime: '4 – 7 Business Days',
      ports: 'Port of Mersin / Izmir (Turkey)',
      description: 'Grown in the renowned apricot orchards of Malatya, Turkey, naturally cured under Mediterranean sunlight. Boasting a rich golden-amber hue, chewy tender texture, and intense natural honeyed flavor without any added refined sugars. Inspected for zero pit fragments and strict SO2 compliance for global market imports.',
      payload: '21 Metric Tons in 1 × 40ft Container'
    },
    'green cardamom': {
      spec: 'Bold Green Cardamom • Grade 8mm+ Extra Bold & 7-8mm',
      moq: '100 Kg (Sample: 10 Kg)',
      packaging: '5 Kg Food-Grade Polylined Master Cartons (10 Kg Outer)',
      moisture: '< 10.0% Max Standard',
      shelfLife: '24 Months Sealed',
      leadTime: '2 – 4 Business Days Fast Track',
      ports: 'Puerto Quetzal (Guatemala), Cochin Port (India)',
      description: 'Often crowned the "Queen of Spices", our green cardamom pods are hand-picked at peak maturity and gently cured in controlled wood-fired kilns. Retains vibrant deep emerald pods, plump black seeds, and high essential oil content (>7.5% Cineole and Terpinyl Acetate). 100% free from artificial green tinting agents.',
      payload: '12 – 14 Metric Tons in 1 × 20ft FCL'
    },
    'sona masoori rice': {
      spec: 'Aged Medium Grain • 100% Sortex Cleaned Non-Sticky',
      moq: '2,000 Kg (2 Metric Tons)',
      packaging: '10 Kg, 25 Kg, 50 Kg BOPP or Non-Woven Laminated Bags',
      moisture: '< 12.5% Max Standard',
      shelfLife: '24 Months in Dry Pest-Controlled Silos',
      leadTime: '3 – 5 Business Days',
      ports: 'Chennai Port (INMAA1), Kakinada Deepwater Port (INKAK1)',
      description: 'Grown in the fertile Krishna and Godavari river basins of South India, Sona Masoori is an aromatic, lightweight medium-grain white rice. Naturally matured for a minimum of 12 months to ensure low starch content, easy digestibility, and fluffy non-clumping grains upon cooking. Extensively exported across North America, Europe, and the Middle East.',
      payload: '25 – 26 Metric Tons in 1 × 20ft FCL'
    },
    'wild forest honey': {
      spec: 'Raw & Unfiltered Multi-Flora • 100% Pure Pollen Preserved',
      moq: '300 Kg (Sample: 25 Kg)',
      packaging: '30 Kg Food-Grade HDPE Pails or 300 Kg Epoxy-Coated Steel Drums',
      moisture: '< 18.0% Max Standard',
      shelfLife: '36 Months (Does not expire under sealed storage)',
      leadTime: '3 – 6 Business Days',
      ports: 'JNPT Mumbai (INNSA1), Mundra Port (INMUN1)',
      description: 'Wild forest honey sustainably harvested by indigenous forest gatherers from deep flora sanctuaries. Unpasteurized and gravity-filtered through fine stainless mesh to preserve live enzymes (invertase, diastase), trace minerals, and natural bee pollen. Verified with NMR testing (Nuclear Magnetic Resonance) for 0% C3/C4 syrup adulteration and zero synthetic antibiotics.',
      payload: '19 – 21 Metric Tons in 1 × 20ft FCL'
    },
    'basmati rice': {
      spec: 'Traditional & 1121 Extra Long Grain • Aged 2 Years',
      moq: '2,000 Kg (2 Metric Tons)',
      packaging: '25 Kg / 50 Kg Non-Woven Laminated Export Sacks or Jute Bags with Poly-Liner',
      moisture: '< 12.0% Max',
      shelfLife: '24 Months in Controlled Aerated Silos',
      leadTime: '3 – 5 Business Days',
      ports: 'Mundra Port (INMUN1), Kandla Port (INIXY1)',
      description: 'Cultivated in the pristine Himalayan foothills fed by mineral-rich snowmelt. Our 1121 Basmati Rice elongates to over twice its raw grain length (>18mm) upon cooking. Characterized by unmatched floral aroma (2-acetyl-1-pyrroline), needle-slender grains, and delicate pearlescent appearance.',
      payload: '25 – 26 Metric Tons in 1 × 20ft FCL'
    },
    'coconut oil': {
      spec: 'Cold-Pressed Virgin • 100% Raw Extra Virgin',
      moq: '500 Liters',
      packaging: '200 Liter Food-Grade Poly Drums or 1,000 Liter Flexitanks / IBC Totes',
      moisture: '< 0.15% Moisture Standard',
      shelfLife: '24 Months in Sealed Containers',
      leadTime: '4 – 7 Business Days',
      ports: 'Tanjung Priok (Indonesia), Cochin Port (India)',
      description: 'Cold-pressed from freshly harvested mature organic coconuts within 48 hours of opening. Extracted mechanically without chemical solvents, heat refining, or bleaching. Boasts high Lauric Acid content (>50%) and fresh tropical aroma.',
      payload: '21 Metric Tons in Flexitank inside 20ft Container'
    },
    'wheat': {
      spec: 'Sharbati & Hard Red Winter Grade • High Gluten Content (>12%)',
      moq: '5,000 Kg (5 Metric Tons)',
      packaging: '50 Kg PP Woven Export Sacks with UV Protection',
      moisture: '< 11.0% Max',
      shelfLife: '24 Months Dry Silo Storage',
      leadTime: '3 – 5 Days',
      ports: 'Kandla Port, Mundra Port',
      description: 'Sun-ripened golden wheat grain characterized by high protein density, high hectolitre weight (>78 kg/hl), and low foreign matter (<0.5%). Mechanically winnowed and sortex-separated for uniform milling yield into premium flour.',
      payload: '26 Metric Tons in 1 × 20ft FCL'
    },
    'green tea': {
      spec: 'Whole Leaf Sencha & Chunmee • High EGCG Antioxidants',
      moq: '200 Kg',
      packaging: '10 Kg Aluminum Foil Multi-Barrier Bags in Master Cartons',
      moisture: '< 6.5% Max',
      shelfLife: '24 Months Sealed',
      leadTime: '3 – 6 Business Days',
      ports: 'Shanghai Port, Kolkata Port',
      description: 'Freshly plucked tender two-leaves-and-a-bud steamed and pan-fired to preserve green chlorophyll pigments and polyphenol antioxidants. Yields a delicate emerald-yellow liquor with crisp vegetive sweetness.',
      payload: '10 – 12 Metric Tons in 1 × 40ft HC Container'
    }
  };

  // Helper to generate dynamic fallback specifications
  function getProductDetails(name, category, origin, spec, price) {
    const key = (name || '').toLowerCase().trim();
    if (PRODUCT_SPECS_DB[key]) {
      return PRODUCT_SPECS_DB[key];
    }

    // Category based realistic fallbacks
    const cat = (category || 'commodities').toLowerCase();
    let packaging = '25 / 50 Kg Heavy-Duty Export Polypropylene Bags';
    let moq = '500 Kg';
    let moisture = '< 12.0% Max';
    let shelfLife = '24 Months in Cool, Dry Ambient Storage';
    let payload = '18 – 22 Metric Tons in 1 × 20ft FCL';

    if (cat === 'spices') {
      packaging = '25 Kg Vacuum-Sealed HDPE Bags / Cartons';
      moq = '250 Kg';
      moisture = '< 10.5% Max Standard';
      payload = '14 – 16 Metric Tons in 1 × 20ft FCL';
    } else if (cat === 'dryfruits') {
      packaging = '10 / 20 Kg Nitrogen-Flushed Vacuum Cartons';
      moq = '250 Kg';
      moisture = '< 6.0% Max';
      shelfLife = '18 Months under Temperature Controlled Warehousing';
      payload = '18 Metric Tons in 1 × 40ft HC Container';
    } else if (cat === 'grains' || cat === 'pulses') {
      packaging = '25 / 50 Kg BOPP Laminated Sacks';
      moq = '1,000 Kg (1 MT)';
      moisture = '< 12.5% Max';
      payload = '25 – 26 Metric Tons in 1 × 20ft FCL';
    } else if (cat === 'oils') {
      packaging = '200 Liter Steel Drums / 1,000 Liter Food-Grade IBC Totes';
      moq = '500 Liters';
      moisture = '< 0.2% Max';
      payload = '20 Metric Tons in Flexitank';
    }

    const description = `Premium quality ${name} sourced under strict international export standards from ${origin || 'certified global suppliers'}. Every consignment undergoes rigorous pre-shipment quality inspection, sortex grading, and phytosanitary verification to guarantee zero contamination, uniform grade grading, and complete shelf-life stability. Fully compliant with international food safety protocols (FSSAI, ISO 22000, Codex Alimentarius).`;

    return {
      spec: spec || 'Standard International Export Grade',
      moq: moq,
      packaging: packaging,
      moisture: moisture,
      shelfLife: shelfLife,
      leadTime: '3 – 5 Business Days Post Export Clearance',
      ports: 'Mundra Port (INMUN1), Nhava Sheva (INNSA1)',
      description: description,
      payload: payload
    };
  }

  // Main Product Modal Controller
  window.ConceptProductModal = {
    currentIndex: 0,
    productCards: [],

    // 1. Initialize System & Inject DOM
    init: function () {
      this.injectModalDOM();
      this.refreshProductCards();
      this.bindCardClicks();
      this.bindModalEvents();
    },

    // 2. Refresh List of Product Cards from DOM
    refreshProductCards: function () {
      this.productCards = Array.from(document.querySelectorAll('.product-card'));
    },

    // 3. Inject Modal DOM Structure
    injectModalDOM: function () {
      if (document.getElementById('productDetailsModalOverlay')) return;

      const modalWrapper = document.createElement('div');
      modalWrapper.innerHTML = `
        <div id="productDetailsModalOverlay" class="product-modal-overlay" aria-hidden="true" role="dialog" aria-modal="true" aria-labelledby="modalProductTitle">
          <div class="product-modal-container">
            
            <!-- Floating Close Button -->
            <button class="product-modal-close-btn" id="modalCloseBtn" aria-label="Close Product Details">
              <i class="fa-solid fa-xmark"></i>
            </button>

            <!-- 2-Column Body -->
            <div class="product-modal-body">
              
              <!-- Left Column: Image & Quality Assurances -->
              <div class="product-modal-media-col">
                <div class="product-modal-image-wrap">
                  <span class="modal-badge-tag" id="modalBadgeTag">Featured</span>
                  <img src="" alt="" id="modalProductImg" class="modal-main-image">
                  <div class="modal-image-hint"><i class="fa-solid fa-magnifying-glass-plus"></i> Export Grade Verified</div>
                </div>

                <!-- 4 Trust Assurances -->
                <div class="modal-assurances-grid">
                  <div class="modal-assurance-item">
                    <i class="fa-solid fa-shield-halved"></i>
                    <span>100% Quality Inspected</span>
                  </div>
                  <div class="modal-assurance-item">
                    <i class="fa-solid fa-certificate"></i>
                    <span>Phytosanitary &amp; Lab Cleared</span>
                  </div>
                  <div class="modal-assurance-item">
                    <i class="fa-solid fa-boxes-stacked"></i>
                    <span>Palletized &amp; Container Ready</span>
                  </div>
                  <div class="modal-assurance-item">
                    <i class="fa-solid fa-ship"></i>
                    <span>FOB / CIF Global Freight</span>
                  </div>
                </div>
              </div>

              <!-- Right Column: Product Specs & Ordering -->
              <div class="product-modal-info-col">
                
                <!-- Meta tags row -->
                <div class="modal-meta-row">
                  <span class="modal-cat-pill" id="modalCatPill">Spices</span>
                  <span class="modal-origin-pill" id="modalOriginPill"><span>🇮🇳</span> Origin: India</span>
                  <span class="modal-stock-tag"><i class="fa-solid fa-circle-check"></i> In Export Stock</span>
                </div>

                <!-- Title & Spec -->
                <h2 class="modal-title" id="modalProductTitle">Product Title</h2>
                <div class="modal-spec" id="modalProductSpec">Product Specification Subtitle</div>

                <!-- Rating -->
                <div class="modal-rating-row">
                  <div class="modal-stars" id="modalStars">
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star"></i>
                    <i class="fa-solid fa-star-half-stroke"></i>
                  </div>
                  <strong class="modal-rating-score" id="modalRatingScore">4.8</strong>
                  <span class="modal-reviews-count" id="modalReviewCount">(110 Verified Trade Reviews)</span>
                </div>

                <!-- Price Box & Bulk Tiers -->
                <div class="modal-price-card">
                  <div class="modal-price-primary">
                    <span class="modal-currency">₹</span>
                    <span class="modal-price-val" id="modalPriceVal">0.00</span>
                    <span class="modal-price-unit" id="modalPriceUnit">/ Kg</span>
                    <span class="modal-incoterm-badge">Ex-Works / FOB</span>
                  </div>
                  <div class="modal-tiers-row">
                    <span class="modal-tier-pill active" title="Standard Order Rate">MOQ - 499 Units: Base Rate</span>
                    <span class="modal-tier-pill" title="Bulk Wholesale Discount">500 - 1,999 Units: <strong>-5% Volume Off</strong></span>
                    <span class="modal-tier-pill" title="Container Load Rate">2,000+ Units (FCL): <strong>Container Tariff</strong></span>
                  </div>
                </div>

                <!-- 4 Quick Specs Matrix -->
                <div class="modal-specs-grid">
                  <div class="modal-spec-cell">
                    <span class="modal-spec-cell-label"><i class="fa-solid fa-box"></i> Packaging</span>
                    <span class="modal-spec-cell-val" id="modalPackaging">25 / 50 Kg Vacuum HDPE</span>
                  </div>
                  <div class="modal-spec-cell">
                    <span class="modal-spec-cell-label"><i class="fa-solid fa-scale-balanced"></i> Min Order (MOQ)</span>
                    <span class="modal-spec-cell-val" id="modalMoq">500 Kg</span>
                  </div>
                  <div class="modal-spec-cell">
                    <span class="modal-spec-cell-label"><i class="fa-solid fa-droplet"></i> Moisture Content</span>
                    <span class="modal-spec-cell-val" id="modalMoisture">&lt; 11.5% Max</span>
                  </div>
                  <div class="modal-spec-cell">
                    <span class="modal-spec-cell-label"><i class="fa-solid fa-clock"></i> Shelf Life</span>
                    <span class="modal-spec-cell-val" id="modalShelfLife">24 Months</span>
                  </div>
                </div>

                <!-- Quantity Stepper & Order Calculation -->
                <div class="modal-order-section">
                  <div class="modal-stepper-row">
                    <div class="modal-qty-control">
                      <span class="modal-qty-label">Order Quantity:</span>
                      <div class="modal-stepper-box">
                        <button type="button" class="modal-step-btn" id="modalMinusBtn" aria-label="Decrease quantity">−</button>
                        <input type="number" class="modal-step-input" id="modalQtyInput" value="25" min="1" max="100000">
                        <button type="button" class="modal-step-btn" id="modalPlusBtn" aria-label="Increase quantity">+</button>
                      </div>
                    </div>
                    <div class="modal-total-calc">
                      <span class="modal-total-calc-label">Calculated Subtotal:</span>
                      <strong class="modal-total-calc-val" id="modalTotalCalc">₹0.00</strong>
                    </div>
                  </div>

                  <!-- Action Buttons -->
                  <div class="modal-actions-grid">
                    <button type="button" class="modal-btn-add-cart" id="modalAddCartBtn">
                      <i class="fa-solid fa-cart-shopping"></i>
                      <span>Add to Trade Cart</span>
                    </button>
                    <button type="button" class="modal-btn-rfq" id="modalRfqBtn">
                      <i class="fa-solid fa-file-invoice"></i>
                      <span>Request Proforma / RFQ</span>
                    </button>
                  </div>
                </div>

                <!-- Interactive Tabs: Overview, Logistics, Quality -->
                <div class="modal-tabs-container">
                  <div class="modal-tabs-nav" role="tablist">
                    <button type="button" class="modal-tab-btn active" data-tab="overview" role="tab"><i class="fa-solid fa-circle-info"></i> Overview</button>
                    <button type="button" class="modal-tab-btn" data-tab="logistics" role="tab"><i class="fa-solid fa-truck-fast"></i> Logistics &amp; Ports</button>
                    <button type="button" class="modal-tab-btn" data-tab="certs" role="tab"><i class="fa-solid fa-stamp"></i> Certifications</button>
                  </div>

                  <!-- Tab 1: Overview -->
                  <div class="modal-tab-pane active" id="modalTabOverview">
                    <p id="modalDescText" style="margin: 0;">Comprehensive product description will load here.</p>
                  </div>

                  <!-- Tab 2: Logistics -->
                  <div class="modal-tab-pane" id="modalTabLogistics">
                    <div class="modal-logistics-list">
                      <div class="modal-logistics-item">
                        <i class="fa-solid fa-box-open"></i>
                        <div><strong>Container Capacity:</strong> <span id="modalPayload">18 – 24 MT in 40ft High Cube Container</span></div>
                      </div>
                      <div class="modal-logistics-item">
                        <i class="fa-solid fa-clock-rotate-left"></i>
                        <div><strong>Lead Time:</strong> <span id="modalLeadTime">3 – 5 Business Days Post Export Clearance</span></div>
                      </div>
                      <div class="modal-logistics-item">
                        <i class="fa-solid fa-anchor"></i>
                        <div><strong>Primary Origin Ports:</strong> <span id="modalPorts">Mundra Port (INMUN1), Nhava Sheva (INNSA1)</span></div>
                      </div>
                      <div class="modal-logistics-item">
                        <i class="fa-solid fa-shield-halved"></i>
                        <div><strong>Trade Incoterms:</strong> FOB, CIF, CFR, EXW (Ex-Works), DAP</div>
                      </div>
                    </div>
                  </div>

                  <!-- Tab 3: Certifications -->
                  <div class="modal-tab-pane" id="modalTabCerts">
                    <div class="modal-certs-wrap">
                      <span class="modal-cert-pill"><i class="fa-solid fa-circle-check"></i> FSSAI Certified</span>
                      <span class="modal-cert-pill"><i class="fa-solid fa-circle-check"></i> ISO 22000:2018</span>
                      <span class="modal-cert-pill"><i class="fa-solid fa-circle-check"></i> APEDA Registered</span>
                      <span class="modal-cert-pill"><i class="fa-solid fa-circle-check"></i> Phytosanitary Cleared</span>
                      <span class="modal-cert-pill"><i class="fa-solid fa-circle-check"></i> SGS Pre-Shipment Inspection</span>
                      <span class="modal-cert-pill"><i class="fa-solid fa-circle-check"></i> Certificate of Origin (COO)</span>
                    </div>
                  </div>
                </div>

              </div> <!-- /info-col -->

            </div> <!-- /modal-body -->

            <!-- Footer: Prev / Next Navigation -->
            <div class="product-modal-footer">
              <button type="button" class="modal-footer-nav-btn" id="modalPrevBtn">
                <i class="fa-solid fa-chevron-left"></i> Previous Product
              </button>
              <span class="modal-counter-indicator" id="modalCounter">Product 1 of 32</span>
              <button type="button" class="modal-footer-nav-btn" id="modalNextBtn">
                Next Product <i class="fa-solid fa-chevron-right"></i>
              </button>
            </div>

          </div>
        </div>
      `;

      document.body.appendChild(modalWrapper);
    },

    // 4. Bind Card Clicks & Add Quick View Badge
    bindCardClicks: function () {
      this.productCards.forEach((card, index) => {
        const thumbWrap = card.querySelector('.product-card-thumb-wrap');
        const img = card.querySelector('.product-thumb-img');
        const title = card.querySelector('.product-item-title');
        const wishlistBtn = card.querySelector('.card-wishlist-btn');
        const stepperBox = card.querySelector('.qty-stepper-box');
        const addCartBtn = card.querySelector('.btn-card-add-cart');

        // Add Quick View badge overlay to thumbnail wrapper if not present
        if (thumbWrap && !thumbWrap.querySelector('.product-quick-view-badge')) {
          const quickBadge = document.createElement('span');
          quickBadge.className = 'product-quick-view-badge';
          quickBadge.innerHTML = '<i class="fa-solid fa-expand"></i> View Details';
          thumbWrap.appendChild(quickBadge);
        }

        // Prevent wishlist, steppers, and add cart buttons from triggering modal
        [wishlistBtn, stepperBox, addCartBtn].forEach(el => {
          if (el) {
            el.addEventListener('click', (e) => {
              e.stopPropagation();
            });
          }
        });

        // Trigger modal on thumbnail wrapper, image, or title
        if (thumbWrap && !thumbWrap.dataset.modalBound) {
          thumbWrap.dataset.modalBound = 'true';
          thumbWrap.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            ConceptProductModal.refreshProductCards();
            const currentIdx = ConceptProductModal.productCards.indexOf(card);
            ConceptProductModal.openModal(currentIdx !== -1 ? currentIdx : index);
          });
        }

        if (title && !title.dataset.modalBound) {
          title.dataset.modalBound = 'true';
          title.addEventListener('click', (e) => {
            e.preventDefault();
            e.stopPropagation();
            ConceptProductModal.refreshProductCards();
            const currentIdx = ConceptProductModal.productCards.indexOf(card);
            ConceptProductModal.openModal(currentIdx !== -1 ? currentIdx : index);
          });
        }
      });
    },

    // 5. Open Modal with Product Data
    openModal: function (index) {
      this.refreshProductCards();
      if (index < 0 || index >= this.productCards.length) return;
      this.currentIndex = index;

      const card = this.productCards[index];
      const titleEl = card.querySelector('.product-item-title');
      const specEl = card.querySelector('.product-item-spec');
      const originTagEl = card.querySelector('.product-origin-tag');
      const badgeEl = card.querySelector('.card-badge-pill');
      const imgEl = card.querySelector('.product-thumb-img');
      const priceVal = parseFloat(card.getAttribute('data-price')) || 45;
      const category = card.getAttribute('data-category') || 'Commodities';
      const origin = card.getAttribute('data-origin') || 'Global';
      const ratingScore = card.querySelector('.product-rating-row strong')?.textContent.trim() || '4.8';
      const reviewCount = card.querySelector('.product-rating-row span')?.textContent.trim() || '(95)';
      const cardQtyInput = card.querySelector('.qty-input-field');

      const name = titleEl ? titleEl.textContent.trim() : 'Premium Export Commodity';
      const spec = specEl ? specEl.textContent.trim() : 'Standard International Grade';
      const imgSrc = imgEl ? imgEl.getAttribute('src') : '';
      const imgAlt = imgEl ? imgEl.getAttribute('alt') : name;
      const badgeText = badgeEl ? badgeEl.textContent.trim() : 'Export Grade';
      const originHtml = originTagEl ? originTagEl.innerHTML : `<span>🌐</span> Origin: ${origin}`;

      // Get rich detailed specs from database or generator
      const details = getProductDetails(name, category, origin, spec, priceVal);

      // Populate Modal Elements
      const modalOverlay = document.getElementById('productDetailsModalOverlay');
      const modalImg = document.getElementById('modalProductImg');
      const modalBadgeTag = document.getElementById('modalBadgeTag');
      const modalCatPill = document.getElementById('modalCatPill');
      const modalOriginPill = document.getElementById('modalOriginPill');
      const modalTitle = document.getElementById('modalProductTitle');
      const modalSpec = document.getElementById('modalProductSpec');
      const modalRatingScoreEl = document.getElementById('modalRatingScore');
      const modalReviewCountEl = document.getElementById('modalReviewCount');
      const modalPriceValEl = document.getElementById('modalPriceVal');
      const modalPackagingEl = document.getElementById('modalPackaging');
      const modalMoqEl = document.getElementById('modalMoq');
      const modalMoistureEl = document.getElementById('modalMoisture');
      const modalShelfLifeEl = document.getElementById('modalShelfLife');
      const modalDescTextEl = document.getElementById('modalDescText');
      const modalPayloadEl = document.getElementById('modalPayload');
      const modalLeadTimeEl = document.getElementById('modalLeadTime');
      const modalPortsEl = document.getElementById('modalPorts');
      const modalQtyInput = document.getElementById('modalQtyInput');
      const modalCounterEl = document.getElementById('modalCounter');

      if (modalImg) {
        modalImg.src = imgSrc;
        modalImg.alt = imgAlt;
      }

      if (modalBadgeTag) {
        modalBadgeTag.textContent = badgeText;
        modalBadgeTag.style.background = (badgeEl && getComputedStyle(badgeEl).backgroundColor) || '#d97706';
      }

      if (modalCatPill) modalCatPill.textContent = category.toUpperCase();
      if (modalOriginPill) modalOriginPill.innerHTML = originHtml;
      if (modalTitle) modalTitle.textContent = name;
      if (modalSpec) modalSpec.textContent = details.spec || spec;
      if (modalRatingScoreEl) modalRatingScoreEl.textContent = ratingScore;
      if (modalReviewCountEl) modalReviewCountEl.textContent = `${reviewCount} Verified Trade Reviews`;
      
      if (modalPriceValEl) {
        modalPriceValEl.textContent = priceVal.toLocaleString('en-IN', {
          minimumFractionDigits: 2,
          maximumFractionDigits: 2
        });
      }

      // Specs
      if (modalPackagingEl) modalPackagingEl.textContent = details.packaging;
      if (modalMoqEl) modalMoqEl.textContent = details.moq;
      if (modalMoistureEl) modalMoistureEl.textContent = details.moisture;
      if (modalShelfLifeEl) modalShelfLifeEl.textContent = details.shelfLife;
      if (modalDescTextEl) modalDescTextEl.textContent = details.description;
      if (modalPayloadEl) modalPayloadEl.textContent = details.payload;
      if (modalLeadTimeEl) modalLeadTimeEl.textContent = details.leadTime;
      if (modalPortsEl) modalPortsEl.textContent = details.ports;

      // Quantity & Initial Subtotal
      const initialQty = cardQtyInput ? (parseInt(cardQtyInput.value) || 25) : 25;
      if (modalQtyInput) {
        modalQtyInput.value = initialQty;
        modalQtyInput.dataset.price = priceVal;
        modalQtyInput.dataset.name = name;
        modalQtyInput.dataset.spec = spec;
        modalQtyInput.dataset.origin = origin;
        modalQtyInput.dataset.image = imgSrc;
      }
      this.updateLiveSubtotal();

      // Navigation Counter (Filter-aware)
      const visibleCards = this.productCards.filter(c => c.style.display !== 'none');
      const visIdx = visibleCards.indexOf(card);
      if (modalCounterEl) {
        if (visibleCards.length < this.productCards.length && visIdx !== -1) {
          modalCounterEl.textContent = `Product ${visIdx + 1} of ${visibleCards.length} (Filtered)`;
        } else {
          modalCounterEl.textContent = `Product ${index + 1} of ${this.productCards.length}`;
        }
      }

      // Reset Tabs to Overview
      this.switchTab('overview');

      // Open Modal
      if (modalOverlay) {
        modalOverlay.classList.add('active');
        modalOverlay.setAttribute('aria-hidden', 'false');
        document.body.style.overflow = 'hidden';
      }
    },

    // 6. Close Modal
    closeModal: function () {
      const modalOverlay = document.getElementById('productDetailsModalOverlay');
      if (modalOverlay) {
        modalOverlay.classList.remove('active');
        modalOverlay.setAttribute('aria-hidden', 'true');
        document.body.style.overflow = '';
      }
    },

    // 7. Update Live Subtotal Calculator
    updateLiveSubtotal: function () {
      const modalQtyInput = document.getElementById('modalQtyInput');
      const modalTotalCalc = document.getElementById('modalTotalCalc');
      if (!modalQtyInput || !modalTotalCalc) return;

      const qty = parseInt(modalQtyInput.value) || 1;
      const price = parseFloat(modalQtyInput.dataset.price) || 0;
      const subtotal = qty * price;

      modalTotalCalc.textContent = '₹' + subtotal.toLocaleString('en-IN', {
        minimumFractionDigits: 2,
        maximumFractionDigits: 2
      });
    },

    // 8. Switch Tab in Modal
    switchTab: function (tabName) {
      document.querySelectorAll('.modal-tab-btn').forEach(btn => {
        if (btn.getAttribute('data-tab') === tabName) {
          btn.classList.add('active');
        } else {
          btn.classList.remove('active');
        }
      });

      const paneMap = {
        'overview': 'modalTabOverview',
        'logistics': 'modalTabLogistics',
        'certs': 'modalTabCerts'
      };

      Object.entries(paneMap).forEach(([tab, paneId]) => {
        const pane = document.getElementById(paneId);
        if (pane) {
          if (tab === tabName) {
            pane.classList.add('active');
          } else {
            pane.classList.remove('active');
          }
        }
      });
    },

    // 9. Bind Modal Events
    bindModalEvents: function () {
      const modalOverlay = document.getElementById('productDetailsModalOverlay');
      const closeBtn = document.getElementById('modalCloseBtn');
      const minusBtn = document.getElementById('modalMinusBtn');
      const plusBtn = document.getElementById('modalPlusBtn');
      const qtyInput = document.getElementById('modalQtyInput');
      const addCartBtn = document.getElementById('modalAddCartBtn');
      const rfqBtn = document.getElementById('modalRfqBtn');
      const prevBtn = document.getElementById('modalPrevBtn');
      const nextBtn = document.getElementById('modalNextBtn');

      // Close handlers
      if (closeBtn) closeBtn.addEventListener('click', () => this.closeModal());
      if (modalOverlay) {
        modalOverlay.addEventListener('click', (e) => {
          if (e.target === modalOverlay) this.closeModal();
        });
      }

      // Quantity controls
      if (minusBtn && qtyInput) {
        minusBtn.addEventListener('click', () => {
          let val = parseInt(qtyInput.value) || 1;
          if (val > 1) {
            qtyInput.value = val - 1;
            this.updateLiveSubtotal();
          }
        });
      }

      if (plusBtn && qtyInput) {
        plusBtn.addEventListener('click', () => {
          let val = parseInt(qtyInput.value) || 1;
          qtyInput.value = val + 1;
          this.updateLiveSubtotal();
        });
      }

      if (qtyInput) {
        qtyInput.addEventListener('input', () => {
          let val = parseInt(qtyInput.value);
          if (isNaN(val) || val < 1) val = 1;
          this.updateLiveSubtotal();
        });
      }

      // Add to Trade Cart from Modal
      if (addCartBtn) {
        addCartBtn.addEventListener('click', () => {
          if (!qtyInput) return;
          const name = qtyInput.dataset.name || 'Commodity Item';
          const spec = qtyInput.dataset.spec || 'Export Standard Grade';
          const price = parseFloat(qtyInput.dataset.price) || 45;
          const origin = qtyInput.dataset.origin || 'Global';
          const image = qtyInput.dataset.image || '';
          const qty = parseInt(qtyInput.value) || 1;
          const id = 'prod_' + name.toLowerCase().replace(/[^a-z0-9]/g, '_');

          if (window.ConceptCart && typeof window.ConceptCart.addItem === 'function') {
            window.ConceptCart.addItem({
              id: id,
              name: name,
              spec: spec,
              price: price,
              unit: 'Kg',
              origin: origin,
              image: image,
              qty: qty
            });
          }

          // Visual Feedback
          const origText = addCartBtn.innerHTML;
          addCartBtn.innerHTML = '<i class="fa-solid fa-check"></i><span>Added to Cart ✓</span>';
          addCartBtn.style.background = '#16a34a';
          addCartBtn.style.borderColor = '#16a34a';

          setTimeout(() => {
            addCartBtn.innerHTML = origText;
            addCartBtn.style.background = '';
            addCartBtn.style.borderColor = '';
          }, 1500);
        });
      }

      // Request RFQ from Modal
      if (rfqBtn) {
        rfqBtn.addEventListener('click', () => {
          this.closeModal();
          if (window.ConceptCart && typeof window.ConceptCart.openRfqModal === 'function') {
            window.ConceptCart.openRfqModal();
          }
        });
      }

      // Prev & Next Product Navigation (Filter-Aware)
      if (prevBtn) {
        prevBtn.addEventListener('click', () => {
          this.refreshProductCards();
          const visible = this.productCards.filter(c => c.style.display !== 'none');
          if (visible.length === 0) return;
          const currentCard = this.productCards[this.currentIndex];
          let visIdx = visible.indexOf(currentCard);
          if (visIdx === -1) visIdx = 0;
          let nextVisIdx = visIdx - 1;
          if (nextVisIdx < 0) nextVisIdx = visible.length - 1;
          const targetCard = visible[nextVisIdx];
          this.openModal(this.productCards.indexOf(targetCard));
        });
      }

      if (nextBtn) {
        nextBtn.addEventListener('click', () => {
          this.refreshProductCards();
          const visible = this.productCards.filter(c => c.style.display !== 'none');
          if (visible.length === 0) return;
          const currentCard = this.productCards[this.currentIndex];
          let visIdx = visible.indexOf(currentCard);
          if (visIdx === -1) visIdx = 0;
          let nextVisIdx = visIdx + 1;
          if (nextVisIdx >= visible.length) nextVisIdx = 0;
          const targetCard = visible[nextVisIdx];
          this.openModal(this.productCards.indexOf(targetCard));
        });
      }

      // Tab Buttons
      document.querySelectorAll('.modal-tab-btn').forEach(btn => {
        btn.addEventListener('click', () => {
          const tab = btn.getAttribute('data-tab');
          if (tab) this.switchTab(tab);
        });
      });

      // Keyboard Accessibility (ESC to close, Left/Right arrows to navigate)
      document.addEventListener('keydown', (e) => {
        if (!modalOverlay || !modalOverlay.classList.contains('active')) return;
        if (e.key === 'Escape') {
          this.closeModal();
        } else if (e.key === 'ArrowLeft') {
          if (prevBtn) prevBtn.click();
        } else if (e.key === 'ArrowRight') {
          if (nextBtn) nextBtn.click();
        }
      });
    }
  };

  // Run on DOM Ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => ConceptProductModal.init());
  } else {
    ConceptProductModal.init();
  }
})();
