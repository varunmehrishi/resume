// Resume site: toggle between the one-page and two-page versions.
// Variant comes from ?v=1p|2p, then localStorage, then the default (1p).
(function () {
  const DEFAULT = "1p";
  const STORAGE_KEY = "resume-variant";
  const toggle = document.getElementById("variant-toggle");
  const pagesEl = document.getElementById("pages");
  const downloadEl = document.getElementById("download");
  const printEl = document.getElementById("print");
  const statusEl = document.getElementById("status");
  let manifest = null;

  function requested() {
    const q = new URLSearchParams(location.search).get("v");
    if (q === "1p" || q === "2p") return q;
    const saved = localStorage.getItem(STORAGE_KEY);
    return saved === "1p" || saved === "2p" ? saved : DEFAULT;
  }

  function render(variant) {
    const v = manifest[variant];
    pagesEl.replaceChildren(
      ...v.pages.map((src, i) => {
        const img = document.createElement("img");
        img.src = src;
        img.alt = `Varun Mehrishi resume, ${v.label.toLowerCase()} version, page ${i + 1} of ${v.pages.length}`;
        img.className = "page";
        img.loading = i === 0 ? "eager" : "lazy";
        img.decoding = "async";
        img.addEventListener("error", () => onImageError(img, variant), { once: true });
        return img;
      })
    );
    downloadEl.href = v.pdf;
    downloadEl.download = v.pdf.split("/").pop().split("?")[0];
    printEl.href = v.pdf;
    statusEl.textContent = `Showing the ${v.label.toLowerCase()} version. Download gives you this same version as PDF.`;
    toggle.querySelectorAll("button").forEach((b) => {
      const on = b.dataset.variant === variant;
      b.setAttribute("aria-pressed", String(on));
    });
    localStorage.setItem(STORAGE_KEY, variant);
    const url = new URL(location.href);
    url.searchParams.set("v", variant);
    history.replaceState(null, "", url);
    document.title = `Varun Mehrishi, resume (${v.label.toLowerCase()})`;
  }

  // If a page image fails (stale cache, blocked SVG), retry once without the cache, then fall back to the PDF itself.
  function onImageError(img, variant) {
    if (!img.dataset.retried) {
      img.dataset.retried = "1";
      img.addEventListener("error", () => onImageError(img, variant), { once: true });
      img.src = img.src.split("?")[0] + "?retry=" + Date.now();
      return;
    }
    const v = manifest[variant];
    const frame = document.createElement("object");
    frame.type = "application/pdf";
    frame.data = v.pdf;
    frame.className = "page pdf-fallback";
    frame.setAttribute("aria-label", "Resume PDF");
    const note = document.createElement("p");
    note.className = "status";
    note.innerHTML = `The page preview could not be loaded in this browser. <a href="${v.pdf}">Open the ${v.label.toLowerCase()} PDF</a> instead.`;
    frame.append(note.cloneNode(true));
    pagesEl.replaceChildren(note, frame);
  }

  function preload(variant) {
    manifest[variant].pages.forEach((src) => { const i = new Image(); i.src = src; });
  }

  const load = window.RESUME_MANIFEST ? Promise.resolve(window.RESUME_MANIFEST) : fetch("pages/manifest.json").then((r) => r.json());
  load
    .then((m) => {
      manifest = m;
      const v = requested();
      render(v);
      preload(v === "1p" ? "2p" : "1p");
      toggle.addEventListener("click", (e) => {
        const b = e.target.closest("button[data-variant]");
        if (b) render(b.dataset.variant);
      });
      toggle.addEventListener("keydown", (e) => {
        if (e.key === "ArrowLeft" || e.key === "ArrowRight") {
          e.preventDefault();
          render(document.querySelector('#variant-toggle [aria-pressed="true"]').dataset.variant === "1p" ? "2p" : "1p");
        }
      });
    })
    .catch(() => { statusEl.textContent = "Could not load the resume pages. Use the download links below."; });
})();
