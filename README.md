# Resume site

Static site that shows the one-page or two-page resume of Varun Mehrishi with a toggle, rendered as SVG pages from the Typst sources, with the PDFs for download.

- `src/` Typst sources (`template.typ`, `VarunMehrishi_Resume_1p.typ`, `VarunMehrishi_Resume_2p.typ`)
- `build.py` compiles `src/` into `pdf/Varun_Mehrishi_Resume_1_page.pdf`, `pdf/Varun_Mehrishi_Resume_2_pages.pdf` and `pages/` plus `pages/manifest.json`. The Download button always serves the version currently shown. These public files are named differently from the local application PDFs (`VarunMehrishi_Resume_1p.pdf`, `_2p.pdf`), which keep contact details and are never copied here.
- `index.html`, `styles.css`, `app.js` the site; `.nojekyll` keeps GitHub Pages from running Jekyll

## Build locally
With Typst installed: `python3 build.py`. Without it: `TYPST_PY_LIB=/path/to/extracted/typst-wheel python3 build.py`.
Preview: `python3 -m http.server 8000` and open http://localhost:8000.

## Deploy to GitHub Pages
```
git init -b main && git add -A && git commit -m "Resume site"
gh repo create resume --public --source=. --push      # or create the repo in the UI and push
```
Then in the repository: Settings > Pages > Source: GitHub Actions (the workflow in `.github/workflows/pages.yml` builds and publishes).
Alternative without Actions: keep the committed `pdf/` and `pages/` folders, choose Source: Deploy from a branch, branch `main`, folder `/ (root)`.
The site then lives at `https://varunmehrishi.github.io/resume/`. Deep links: `?v=1p` or `?v=2p`.

## Custom domain later
1. Settings > Pages > Custom domain: enter the domain; GitHub writes a `CNAME` file into the repo (commit it if you use Actions).
2. DNS: for an apex domain add A records to 185.199.108.153, 185.199.109.153, 185.199.110.153, 185.199.111.153 (and AAAA to GitHub's IPv6 range); for `www` or a subdomain add a CNAME to `varunmehrishi.github.io`.
3. Tick "Enforce HTTPS" once the certificate is issued. All asset paths are relative, so the site works at the repo path and at the domain root unchanged.

## Updating the resume
Edit the files in `src/`, run `python3 build.py`, commit. Keep `src/` in sync with `persona/resume/*.typ` if you edit there.

Contact details: the site builds with the Typst input `web=1`, which removes email and phone from the resume header; LinkedIn and GitHub remain. The application PDFs built without that input keep full contact details.

## Licence
Code (`template.typ`, `build.py`, `index.html`, `styles.css`, `app.js`, `.github/`) is MIT licensed. The resume content (`src/VarunMehrishi_Resume_*.typ`, `pdf/`, `pages/`) is copyright Varun Mehrishi, all rights reserved. See `LICENSE`.
