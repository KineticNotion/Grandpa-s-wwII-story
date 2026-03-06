Original prompt: let evaluate this project. it need to flow cinematically in a story telling way and be acuarate because it is based off a true story. In the image folder, there are images of documents and they're all numbered, and these all correspond with the mission briefings that are kind of summary of what was happening so so during the mission can go to the original text, but I noticed that right now the original tech it's not going to the actual page that it's on these are not lined up. Maybe there's some way we can read the images and put some meta-data into them saying this is what's in the text. Rename the file names to be paid 123 be more descriptive so it's easier to tr. This is an example of kind of just kind of tightening up of what's here what's here is good, but I think we can just clean it up. Make it accurate and any other suggestions you know now that you know the spirit of what we need to do.

2026-03-06
- Refactored the app around `story-data.js` with explicit `documents`, `missions`, and `acts`.
- Renamed the 17 manuscript scan files to descriptive `page-###-...` names and preserved legacy ids in data.
- Fixed mission/source provenance so story steps can target a primary scan instead of defaulting to a mismatched related page.
- Added local OCR generation (`scripts/ocr_pages.swift`) and derived `ocr-data.js`/`ocr-output` for scan review.
- Added `admin.html` as a scan-by-scan editing workspace with original image, OCR, and editable clean reading.
- Added `reading-overrides.js` so admin edits persist in localStorage and flow through to the public viewer.
- Added export paths: JSON overrides in the admin editor, merged `story-data.js` download in the admin editor, and terminal merge via `scripts/apply_reading_overrides.js`.
- Smoke-tested `index.html` and `admin.html` in Playwright; public story step 1 now opens Scan 1 in the modal for its multi-scan sequence, and the admin editor/export controls render correctly.
- Added inline favicons to `index.html` and `admin.html` to remove the browser 404 noise during local review.
- Removed the public `Reading Editor` link from `index.html` so the admin page is no longer advertised to end users.
- Fixed disappearing scan thumbnails by regenerating the HEIF-backed page images as real JPEGs from the original git blobs using `scripts/convert_heif_to_jpeg.swift`.
- Hardened the public modal so switching from clean reading back to image mode reasserts the active scan source.

Open items / next pass:
- Do a browser-side smoke test of `index.html` and `admin.html` after the latest editor/export changes.
- Human-review the clean readings scan by scan; OCR was alignment help, not publication-quality text.
- Consider adding an in-app "apply exported file" note or a small import helper for repo maintenance if the editing workflow becomes frequent.
