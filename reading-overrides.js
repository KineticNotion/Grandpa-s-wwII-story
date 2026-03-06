window.ReadingOverrides = (() => {
  const STORAGE_KEY = 'grandpa-story-reading-overrides';

  function load() {
    try {
      const raw = window.localStorage.getItem(STORAGE_KEY);
      if (!raw) return {};
      const parsed = JSON.parse(raw);
      return parsed && typeof parsed === 'object' ? parsed : {};
    } catch {
      return {};
    }
  }

  function save(overrides) {
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(overrides));
  }

  function apply(documents, overrides = load()) {
    return documents.map((doc) => ({
      ...doc,
      transcription: Object.prototype.hasOwnProperty.call(overrides, doc.id)
        ? overrides[doc.id]
        : doc.transcription
    }));
  }

  function download(overrides = load(), filename = 'reading-overrides.json') {
    const blob = new Blob([JSON.stringify(overrides, null, 2)], { type: 'application/json' });
    const url = URL.createObjectURL(blob);
    const link = document.createElement('a');
    link.href = url;
    link.download = filename;
    link.click();
    URL.revokeObjectURL(url);
  }

  return {
    STORAGE_KEY,
    load,
    save,
    apply,
    download
  };
})();
