# Operation: Grandfather - Documentary Story Map

**A Digital Preservation of a WWII Journey (1943-1946)**

This project is a static web experience designed to preserve the personal history of a World War II soldier with clear source provenance. It combines a curated story map, transcribed journal pages, and supporting historical context so the manuscript remains the primary voice.

## 🗺️ Project Overview

"Operation: Grandfather" transforms a collection of handwritten journal pages and oral history into a documentary-style digital narrative. Users can follow the soldier's path from induction in Los Angeles, through training in the US, the Atlantic crossing, the advance through Europe, and the final return home, while opening the supporting source page for each story step.

## ✨ Key Features

*   **Story Map**: A Leaflet-based route through 16 curated story steps grouped into four acts.
*   **Source Archive**: A page-by-page archive of the scanned manuscript with descriptive titles and legacy image ids preserved for traceability.
*   **Source-Aware Missions**: Every mission card identifies its supporting page and opens the intended original document instead of a generic first page.
*   **Documentary Framing**: Each stop separates exact manuscript excerpts, narrative bridge copy, and archivist notes.
*   **Service Record**: A quieter milestone tracker aligned to the four medals and major service milestones referenced in the manuscript.

## 🚀 How to View

### Online (If hosted)
Simply visit the provided URL to explore the dossier.

### Locally
1.  Download or clone this folder.
2.  Open `index.html` in any modern web browser (Chrome, Safari, Firefox, Edge).
3.  No installation or server is required.

## 📂 Project Structure

*   `index.html`: The main application shell and UI logic.
*   `story-data.js`: Curated document metadata, mission sequencing, and source-aligned narrative copy.
*   `admin.html`: Review workspace for editing scan-by-scan clean readings beside the original scan and OCR.
*   `reading-overrides.js`: Browser-side persistence layer for clean-reading edits made in the admin workspace.
*   `ocr-data.js`: Local OCR text extracted from the manuscript scans for alignment and review.
*   `scripts/apply_reading_overrides.js`: Utility to merge exported reading overrides back into `story-data.js`.
*   `imgs/`: Digitized journal pages and supporting historical photos.
*   `Grandfather's WWII Story_Corrected.md`: The complete corrected transcription of the journal.

## 🛠️ Editing The Clean Readings

1.  Open `admin.html` in your browser.
2.  Review each scan with the original image, OCR reference, and editable clean reading side by side.
3.  Click `Save Current` as you work. Changes are stored in your browser so `index.html` immediately uses them on refresh.
4.  Use `Export JSON` for a portable override file, or `Export story-data.js` to download a repo-ready merged data file.
5.  If you export JSON and want to merge it from the terminal, run `node scripts/apply_reading_overrides.js path/to/overrides.json`.

## 🎖️ Dedication

Dedicated to the memory and service of the men and women of the 135th Evacuation Hospital.

---
*Declassified for Educational Use*
