#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const root = process.cwd();
const sourcePath = path.join(root, 'ocr-output', 'pages.json');
const outputPath = path.join(root, 'ocr-data.js');

const pages = JSON.parse(fs.readFileSync(sourcePath, 'utf8')).pages || [];
const byId = Object.fromEntries(
  pages.map((page) => [
    page.id,
    {
      file: page.file,
      text: page.text || ''
    }
  ])
);

const content = `window.OCR_DATA = ${JSON.stringify(byId, null, 2)};\n`;
fs.writeFileSync(outputPath, content);
console.log(`Wrote ${outputPath}`);
