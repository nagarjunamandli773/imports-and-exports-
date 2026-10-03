const fs = require('fs');
const files = [
  'index.html',
  'about.html',
  'products.html',
  'services.html',
  'global-presence.html',
  'compliance.html',
  'insights.html',
  'contact.html'
];

files.forEach(f => {
  const c = fs.readFileSync(f, 'utf-8');
  const downInsideNav = (c.match(/<span class="nav-arrow-btn"[^>]*>[\s\S]*?fa-chevron-down/g) || []).length;
  const rightInsideNav = (c.match(/<span class="nav-arrow-btn"[^>]*>[\s\S]*?fa-chevron-right/g) || []).length;
  console.log(`${f} -> down: ${downInsideNav}, right: ${rightInsideNav}`);
});
