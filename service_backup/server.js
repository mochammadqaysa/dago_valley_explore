var http = require('http');
var fs = require('fs');
var path = require('path');

var PORT = 8080;
var ROOT = path.join(__dirname, '..');

var MIME_TYPES = {
    '.html': 'text/html',
    '.js': 'application/javascript',
    '.mjs': 'application/javascript',
    '.css': 'text/css',
    '.json': 'application/json',
    '.png': 'image/png',
    '.jpg': 'image/jpeg',
    '.wasm': 'application/wasm',
    '.ico': 'image/x-icon'
};

http.createServer(function (req, res) {
    var filePath = path.join(ROOT, req.url === '/' ? 'index.html' : req.url);

    fs.exists(filePath, function (exists) {
        if (!exists) {
            res.writeHead(404);
            res.end('Not found');
            return;
        }

        var ext = path.extname(filePath);
        var contentType = MIME_TYPES[ext] || 'application/octet-stream';

        res.writeHead(200, {
            'Content-Type': contentType,
            'Access-Control-Allow-Origin': '*'
        });

        fs.createReadStream(filePath).pipe(res);
    });
}).listen(PORT, function () {
    console.log('Server running on port ' + PORT);
});