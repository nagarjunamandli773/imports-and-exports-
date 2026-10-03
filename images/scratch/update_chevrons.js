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

files.forEach(file => {
  let content = fs.readFileSync(file, 'utf-8');
  const regex = /(<span class="nav-arrow-btn"[^>]*>[\s\r\n]*)<i class="fa-solid fa-chevron-down"><\/i>/g;
  const updated = content.replace(regex, '$1<i class="fa-solid fa-chevron-right"></i>');
  if (updated !== content) {
    fs.writeFileSync(file, updated, 'utf-8');
    console.log('Successfully updated forward chevrons in:', file);
  } else {
    console.log('No matches found in:', file);
  }
});
