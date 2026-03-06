#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const root = process.cwd();
const overridesPath = process.argv[2];
const outputPath = process.argv[3] || path.join(root, 'story-data.js');

if (!overridesPath) {
  console.error('Usage: node scripts/apply_reading_overrides.js <overrides.json> [output-path]');
  process.exit(1);
}

global.window = {};
require(path.join(root, 'story-data.js'));

const storyData = global.window.STORY_DATA;
const overrides = JSON.parse(fs.readFileSync(path.resolve(root, overridesPath), 'utf8'));

storyData.documents = storyData.documents.map((doc) => ({
  ...doc,
  transcription: Object.prototype.hasOwnProperty.call(overrides, doc.id)
    ? overrides[doc.id]
    : doc.transcription
}));

const output = `window.STORY_DATA = ${JSON.stringify(storyData, null, 2)};\n`;
fs.writeFileSync(path.resolve(root, outputPath), output);

console.log(`Wrote ${path.resolve(root, outputPath)}`);
