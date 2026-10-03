const fs = require('fs');
const path = require('path');

const filePath = path.join(__dirname, '..', 'products.html');
let html = fs.readFileSync(filePath, 'utf8');

const products = [
  // 1. Basmati Rice
  `            <!-- Product 1: Basmati Rice -->
            <article class="product-card" data-category="grains" data-origin="India" data-price="45">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-bestseller">Best Seller</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_basmati.jpg" alt="Basmati Rice" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Basmati Rice</h3>
                <div class="product-item-spec">Long Grain | Premium Quality</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(120)</span></div>
                <div class="product-price-val">₹45.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Basmati Rice">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 2. Black Pepper
  `            <!-- Product 2: Black Pepper -->
            <article class="product-card" data-category="spices" data-origin="India" data-price="320">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-hotdeal">Hot Deal</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Black Pepper.png" alt="Black Pepper" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Black Pepper</h3>
                <div class="product-item-spec">Pure &amp; Natural</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(98)</span></div>
                <div class="product-price-val">₹320.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Black Pepper">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 3. Masoor Dal
  `            <!-- Product 3: Masoor Dal -->
            <article class="product-card" data-category="pulses" data-origin="Other" data-price="120">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-new">New</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/dal.png" alt="Masoor Dal" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Masoor Dal</h3>
                <div class="product-item-spec">High Protein | Natural</div>
                <div class="product-origin-tag"><span>🇨🇦</span><span>Origin: Canada</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.6</strong><span>(76)</span></div>
                <div class="product-price-val">₹120.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Masoor Dal">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 4. Cashew Nuts
  `            <!-- Product 4: Cashew Nuts -->
            <article class="product-card" data-category="dryfruits" data-origin="Other" data-price="680">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-featured">Premium</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Cashew Nuts.png" alt="Cashew Nuts" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Cashew Nuts</h3>
                <div class="product-item-spec">Premium Grade | Fresh</div>
                <div class="product-origin-tag"><span>🇻🇳</span><span>Origin: Vietnam</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.9</strong><span>(143)</span></div>
                <div class="product-price-val">₹680.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Cashew Nuts">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 5. Coconut Oil
  `            <!-- Product 5: Coconut Oil -->
            <article class="product-card" data-category="oils" data-origin="Other" data-price="250">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Pure</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_coconut_oil.jpg" alt="Coconut Oil" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Coconut Oil</h3>
                <div class="product-item-spec">Cold Pressed | Pure</div>
                <div class="product-origin-tag"><span>🇮🇩</span><span>Origin: Indonesia</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.5</strong><span>(62)</span></div>
                <div class="product-price-val">₹250.00 / Ltr</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Coconut Oil">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 6. Almonds
  `            <!-- Product 6: Almonds -->
            <article class="product-card" data-category="dryfruits" data-origin="USA" data-price="950">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Almonds.png" alt="Almonds" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Almonds</h3>
                <div class="product-item-spec">Premium Quality | Natural</div>
                <div class="product-origin-tag"><span>🇺🇸</span><span>Origin: USA</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(110)</span></div>
                <div class="product-price-val">₹950.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Almonds">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 7. Green Cardamom
  `            <!-- Product 7: Green Cardamom -->
            <article class="product-card" data-category="spices" data-origin="Other" data-price="1200">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-featured">Featured</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Green Cardamom.png" alt="Green Cardamom" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Green Cardamom</h3>
                <div class="product-item-spec">Aromatic | Premium</div>
                <div class="product-origin-tag"><span>🇬🇹</span><span>Origin: Guatemala</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(88)</span></div>
                <div class="product-price-val">₹1,200.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Green Cardamom">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 8. Wheat
  `            <!-- Product 8: Wheat -->
            <article class="product-card" data-category="grains" data-origin="India" data-price="28">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-popular">Popular</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_wheat.jpg" alt="Wheat" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Wheat</h3>
                <div class="product-item-spec">High Grade | Nutrient Rich</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.6</strong><span>(74)</span></div>
                <div class="product-price-val">₹28.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Wheat">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 9. Dried Apricots
  `            <!-- Product 9: Dried Apricots -->
            <article class="product-card" data-category="dryfruits" data-origin="Other" data-price="600">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Dried Apricots.png" alt="Dried Apricots" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Dried Apricots</h3>
                <div class="product-item-spec">Natural | No Added Sugar</div>
                <div class="product-origin-tag"><span>🇹🇷</span><span>Origin: Turkey</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.5</strong><span>(52)</span></div>
                <div class="product-price-val">₹600.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Dried Apricots">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 10. Green Tea
  `            <!-- Product 10: Green Tea -->
            <article class="product-card" data-category="processed" data-origin="Other" data-price="450">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_green_tea.jpg" alt="Green Tea" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Green Tea</h3>
                <div class="product-item-spec">Pure | Healthy</div>
                <div class="product-origin-tag"><span>🇨🇳</span><span>Origin: China</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(90)</span></div>
                <div class="product-price-val">₹450.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Green Tea">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 11. Sona Masoori Rice
  `            <!-- Product 11: Sona Masoori Rice -->
            <article class="product-card" data-category="grains" data-origin="India" data-price="42">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Fresh Crop</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Sona Masoori Rice.png" alt="Sona Masoori Rice" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Sona Masoori Rice</h3>
                <div class="product-item-spec">Lightweight &amp; Aromatic | Medium Grain</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(92)</span></div>
                <div class="product-price-val">₹42.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Sona Masoori Rice">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 12. Yellow Maize Corn
  `            <!-- Product 12: Yellow Maize Corn -->
            <article class="product-card" data-category="grains" data-origin="USA" data-price="24">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-hotdeal">Hot Deal</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_yellow_corn.jpg" alt="Yellow Maize Corn" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Yellow Maize Corn</h3>
                <div class="product-item-spec">Food &amp; Feed Grade | Low Moisture</div>
                <div class="product-origin-tag"><span>🇺🇸</span><span>Origin: USA</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.5</strong><span>(58)</span></div>
                <div class="product-price-val">₹24.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Yellow Maize Corn">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 13. Turmeric Powder
  `            <!-- Product 13: Turmeric Powder -->
            <article class="product-card" data-category="spices" data-origin="India" data-price="140">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_turmeric.jpg" alt="Organic Turmeric Powder" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Turmeric Powder</h3>
                <div class="product-item-spec">High Curcumin 5%+ | Salem Pure</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.9</strong><span>(135)</span></div>
                <div class="product-price-val">₹140.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Turmeric Powder">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 14. Guntur Red Chilli
  `            <!-- Product 14: Guntur Red Chilli -->
            <article class="product-card" data-category="spices" data-origin="India" data-price="165">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-bestseller">Best Seller</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_red_chilli.jpg" alt="Guntur Teja Red Chilli" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Guntur Red Chilli</h3>
                <div class="product-item-spec">Stemless Export Grade | Vibrant Red</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(112)</span></div>
                <div class="product-price-val">₹165.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Guntur Red Chilli">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 15. Cumin Seeds
  `            <!-- Product 15: Cumin Seeds -->
            <article class="product-card" data-category="spices" data-origin="India" data-price="280">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Fresh Crop</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_cumin_seeds.jpg" alt="Cumin Seeds" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Cumin Seeds (Jeera)</h3>
                <div class="product-item-spec">Machine Cleaned 99.5% | Rich Aroma</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.6</strong><span>(84)</span></div>
                <div class="product-price-val">₹280.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Cumin Seeds">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 16. Toor Dal
  `            <!-- Product 16: Toor Dal -->
            <article class="product-card" data-category="pulses" data-origin="India" data-price="145">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-bestseller">Best Seller</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_toor_dal.jpg" alt="Premium Toor Dal" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Toor Dal (Arhar)</h3>
                <div class="product-item-spec">Fatka Quality | Unpolished &amp; Natural</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(110)</span></div>
                <div class="product-price-val">₹145.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Toor Dal">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 17. Kabuli Chickpeas
  `            <!-- Product 17: Kabuli Chickpeas -->
            <article class="product-card" data-category="pulses" data-origin="India" data-price="135">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_chickpeas.jpg" alt="Kabuli Chickpeas" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Kabuli Chickpeas</h3>
                <div class="product-item-spec">12mm Bold Grade | High Fiber</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(94)</span></div>
                <div class="product-price-val">₹135.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Kabuli Chickpeas">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 18. Yellow Moong Dal
  `            <!-- Product 18: Yellow Moong Dal -->
            <article class="product-card" data-category="pulses" data-origin="India" data-price="115">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-popular">Popular</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_moong_dal.jpg" alt="Yellow Moong Dal" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Yellow Moong Dal</h3>
                <div class="product-item-spec">Washed &amp; Cleaned | Easy Digestible</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.6</strong><span>(67)</span></div>
                <div class="product-price-val">₹115.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Yellow Moong Dal">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 19. Alphonso Mangoes
  `            <!-- Product 19: Alphonso Mangoes -->
            <article class="product-card" data-category="fruits" data-origin="India" data-price="850">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-bestseller">Best Seller</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_mangoes.jpg" alt="Alphonso Mangoes" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Alphonso Mangoes</h3>
                <div class="product-item-spec">GI Tagged | Ratnagiri Prime Export</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.9</strong><span>(185)</span></div>
                <div class="product-price-val">₹850.00 / Box</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Alphonso Mangoes">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 20. Royal Gala Apples
  `            <!-- Product 20: Royal Gala Apples -->
            <article class="product-card" data-category="fruits" data-origin="USA" data-price="220">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Fresh Crop</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_apples.jpg" alt="Royal Gala Apples" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Royal Gala Apples</h3>
                <div class="product-item-spec">Crisp &amp; Sweet | Washington Grade A</div>
                <div class="product-origin-tag"><span>🇺🇸</span><span>Origin: USA</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(142)</span></div>
                <div class="product-price-val">₹220.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Royal Gala Apples">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 21. Nashik Red Onions
  `            <!-- Product 21: Nashik Red Onions -->
            <article class="product-card" data-category="fruits" data-origin="India" data-price="35">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-popular">Popular</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_red_onions.jpg" alt="Nashik Red Onions" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Nashik Red Onions</h3>
                <div class="product-item-spec">Export Quality 45mm+ | Fresh Harvest</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(95)</span></div>
                <div class="product-price-val">₹35.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Nashik Red Onions">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 22. Bhagwa Pomegranates
  `            <!-- Product 22: Bhagwa Pomegranates -->
            <article class="product-card" data-category="fruits" data-origin="India" data-price="190">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_pomegranates.jpg" alt="Bhagwa Pomegranates" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Bhagwa Pomegranates</h3>
                <div class="product-item-spec">Ruby Red Arils | Sweet &amp; Juicy</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.9</strong><span>(118)</span></div>
                <div class="product-price-val">₹190.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Bhagwa Pomegranates">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 23. Cavendish Bananas
  `            <!-- Product 23: Cavendish Bananas -->
            <article class="product-card" data-category="fruits" data-origin="India" data-price="40">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-hotdeal">Hot Deal</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_bananas.jpg" alt="Cavendish Bananas" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Cavendish Bananas</h3>
                <div class="product-item-spec">Fresh Golden | Grade A Export</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.6</strong><span>(88)</span></div>
                <div class="product-price-val">₹40.00 / Dozen</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Cavendish Bananas">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 24. Veggie Crate
  `            <!-- Product 24: Farm Fresh Veggie Crate -->
            <article class="product-card" data-category="fruits" data-origin="India" data-price="320">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-organic">Organic</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_vegetable_box.jpg" alt="Farm Fresh Veggie Crate" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Veggie Crate</h3>
                <div class="product-item-spec">Hydroponic &amp; Organic Assorted Mix</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(104)</span></div>
                <div class="product-price-val">₹320.00 / Box</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Veggie Crate">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 25. Extra Virgin Olive Oil
  `            <!-- Product 25: Extra Virgin Olive Oil -->
            <article class="product-card" data-category="oils" data-origin="Other" data-price="650">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-featured">Featured</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_olive_oil.jpg" alt="Extra Virgin Olive Oil" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Extra Virgin Olive Oil</h3>
                <div class="product-item-spec">First Cold Extraction | Acidity &lt;0.4%</div>
                <div class="product-origin-tag"><span>🇪🇸</span><span>Origin: Spain</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.9</strong><span>(126)</span></div>
                <div class="product-price-val">₹650.00 / Ltr</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Olive Oil">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 26. Pure Mustard Oil
  `            <!-- Product 26: Pure Mustard Oil -->
            <article class="product-card" data-category="oils" data-origin="India" data-price="160">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-popular">Popular</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_mustard_oil.jpg" alt="Mustard Oil" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Mustard Oil (Kachi Ghani)</h3>
                <div class="product-item-spec">Traditional Cold Pressed | Strong Pungency</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(89)</span></div>
                <div class="product-price-val">₹160.00 / Ltr</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Mustard Oil">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 27. Refined Sunflower Oil
  `            <!-- Product 27: Refined Sunflower Oil -->
            <article class="product-card" data-category="oils" data-origin="Other" data-price="135">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-hotdeal">Hot Deal</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_sunflower_oil.jpg" alt="Refined Sunflower Oil" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Sunflower Oil</h3>
                <div class="product-item-spec">Triple Refined | High Smoke Point</div>
                <div class="product-origin-tag"><span>🇺🇦</span><span>Origin: Ukraine</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.6</strong><span>(73)</span></div>
                <div class="product-price-val">₹135.00 / Ltr</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Sunflower Oil">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 28. Kashmiri Saffron
  `            <!-- Product 28: Kashmiri Saffron -->
            <article class="product-card" data-category="processed" data-origin="India" data-price="3200">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-featured">Featured</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_saffron.jpg" alt="Pure Kashmiri Saffron" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Kashmiri Saffron (Kesar)</h3>
                <div class="product-item-spec">Mongra Grade A1 | High Crocin Content</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>5.0</strong><span>(64)</span></div>
                <div class="product-price-val">₹3,200.00 / 10g</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Kashmiri Saffron">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 29. Wild Forest Honey
  `            <!-- Product 29: Wild Forest Honey -->
            <article class="product-card" data-category="processed" data-origin="India" data-price="380">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-bestseller">Best Seller</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/Wild Forest Honey.png" alt="Wild Forest Honey" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Wild Forest Honey</h3>
                <div class="product-item-spec">Raw &amp; Unfiltered | 100% Pure Pollen</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(98)</span></div>
                <div class="product-price-val">₹380.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Wild Forest Honey">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 30. Mango Pulp
  `            <!-- Product 30: Mango Pulp -->
            <article class="product-card" data-category="processed" data-origin="India" data-price="210">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-popular">Popular</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_mango_pulp.jpg" alt="Alphonso Mango Pulp" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Mango Pulp (Aamras)</h3>
                <div class="product-item-spec">Aseptic Canning | No Preservatives</div>
                <div class="product-origin-tag"><span>🇮🇳</span><span>Origin: India</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.9</strong><span>(115)</span></div>
                <div class="product-price-val">₹210.00 / Can</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Mango Pulp">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 31. California Walnuts
  `            <!-- Product 31: California Walnuts -->
            <article class="product-card" data-category="dryfruits" data-origin="USA" data-price="820">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-featured">Featured</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/background images/California Walnuts.png" alt="California Walnuts" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">California Walnuts</h3>
                <div class="product-item-spec">Extra Light Halves | Heart Healthy</div>
                <div class="product-origin-tag"><span>🇺🇸</span><span>Origin: USA</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.8</strong><span>(87)</span></div>
                <div class="product-price-val">₹820.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="California Walnuts">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`,

  // 32. Golden Afghan Raisins
  `            <!-- Product 32: Golden Afghan Raisins -->
            <article class="product-card" data-category="dryfruits" data-origin="Other" data-price="340">
              <div class="product-card-thumb-wrap">
                <span class="card-badge-pill badge-hotdeal">Hot Deal</span>
                <button class="card-wishlist-btn" aria-label="Add to Wishlist"><i class="fa-regular fa-heart"></i></button>
                <img src="images/products_crop/prod_golden_raisins.jpg" alt="Golden Afghan Raisins" class="product-thumb-img">
              </div>
              <div class="product-card-body">
                <h3 class="product-item-title">Golden Raisins (Kishmish)</h3>
                <div class="product-item-spec">Long Seedless | Naturally Sweet</div>
                <div class="product-origin-tag"><span>🇦🇫</span><span>Origin: Afghanistan</span></div>
                <div class="product-rating-row"><i class="fa-solid fa-star"></i><strong>4.7</strong><span>(79)</span></div>
                <div class="product-price-val">₹340.00 / Kg</div>
                <div class="card-action-row">
                  <div class="qty-stepper-box">
                    <button class="qty-step-btn btn-minus">−</button>
                    <input type="text" class="qty-input-field" value="1" readonly>
                    <button class="qty-step-btn btn-plus">+</button>
                  </div>
                  <button class="btn-card-add-cart" data-name="Golden Raisins">
                    <i class="fa-solid fa-cart-shopping"></i><span>Add to Cart</span>
                  </button>
                </div>
              </div>
            </article>`
];

const startMarker = '<div class="products-grid-5cols" id="productsGridContainer">';
const endMarker = '</div>\n        </section>';

const startIdx = html.indexOf(startMarker);
const endIdx = html.indexOf(endMarker, startIdx);

if (startIdx !== -1 && endIdx !== -1) {
  const newGridContent = `${startMarker}\n\n${products.join('\n\n')}\n\n          `;
  const updatedHtml = html.substring(0, startIdx) + newGridContent + html.substring(endIdx);
  fs.writeFileSync(filePath, updatedHtml, 'utf8');
  console.log('Products successfully reordered to match user reference image!');
} else {
  console.error('Markers not found', { startIdx, endIdx });
}
