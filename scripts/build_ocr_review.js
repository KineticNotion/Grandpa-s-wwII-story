#!/usr/bin/env node

const fs = require('fs');
const path = require('path');

const root = process.cwd();
const storyDataPath = path.join(root, 'story-data.js');
const ocrManifestPath = path.join(root, 'ocr-output', 'pages.json');
const outputPath = path.join(root, 'ocr-output', 'review.json');

global.window = {};
require(storyDataPath);

const storyData = global.window.STORY_DATA;
const ocrManifest = JSON.parse(fs.readFileSync(ocrManifestPath, 'utf8'));
const ocrById = new Map(ocrManifest.pages.map((page) => [page.id, page]));

const review = storyData.documents.map((doc) => ({
  id: doc.id,
  legacyId: doc.legacyId,
  title: doc.title,
  file: doc.file,
  summary: doc.summary,
  currentTranscription: doc.transcription,
  ocrText: (ocrById.get(doc.id) || {}).text || ''
}));

fs.writeFileSync(outputPath, JSON.stringify({
  generatedAt: new Date().toISOString(),
  documentCount: review.length,
  documents: review
}, null, 2));

console.log(`Wrote ${outputPath}`);
