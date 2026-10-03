const http = require('http');
const fs = require('fs');
const path = require('path');

let PORT = process.env.PORT || 3000;

const MIME_TYPES = {
  '.html': 'text/html',
  '.css': 'text/css',
  '.js': 'text/javascript',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.jpeg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.ico': 'image/x-icon',
  '.mp4': 'video/mp4',
  '.webm': 'video/webm'
};

function createServer(portToUse) {
  const server = http.createServer((req, res) => {
    let reqPath = req.url === '/' ? 'index.html' : req.url;
    const cleanUrl = reqPath.split('?')[0].split('#')[0];
    if (cleanUrl === '/login' || cleanUrl === '/register') {
      reqPath = 'login.html';
    } else if (!path.extname(cleanUrl) && fs.existsSync(path.join(__dirname, cleanUrl + '.html'))) {
      reqPath = cleanUrl + '.html';
    }
    let filePath = path.join(__dirname, reqPath);
    filePath = decodeURIComponent(filePath);

    const ext = path.extname(filePath).toLowerCase();
    const contentType = MIME_TYPES[ext] || 'application/octet-stream';

    fs.readFile(filePath, (err, content) => {
      if (err) {
        if (err.code === 'ENOENT') {
          res.writeHead(404, { 'Content-Type': 'text/html' });
          res.end('<h1>404 Not Found</h1>', 'utf-8');
        } else {
          res.writeHead(500);
          res.end(`Server Error: ${err.code}`);
        }
      } else {
        res.writeHead(200, {
          'Content-Type': contentType,
          'Cache-Control': 'no-cache, no-store, must-revalidate',
          'Pragma': 'no-cache',
          'Expires': '0'
        });
        res.end(content, 'utf-8');
      }
    });
  });

  server.on('error', (err) => {
    if (err.code === 'EADDRINUSE') {
      console.log(`Port ${portToUse} is currently in use. Trying port ${portToUse + 1}...`);
      createServer(portToUse + 1);
    } else {
      console.error('Server error:', err);
    }
  });

  server.listen(portToUse, () => {
    console.log(`\n==================================================`);
    console.log(`🚀 Global Orbit Web Portal is running!`);
    console.log(`🌐 Local URL: http://localhost:${portToUse}/`);
    console.log(`==================================================\n`);
  });
}

createServer(PORT);
