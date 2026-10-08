#!/usr/bin/env python3
"""Build the resume site assets from the Typst sources in src/.

Outputs: pdf/<name>.pdf, pages/<variant>-<n>.svg, pages/manifest.json.
Builds with the Typst input web=1, which drops email and phone from the header (LinkedIn is the contact channel).
Uses the `typst` CLI when present, otherwise the `typst` Python package
(set TYPST_PY_LIB to a directory containing the extracted wheel if it is not installed).
"""
import json, os, shutil, subprocess, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC, PDF, PAGES = (os.path.join(HERE, d) for d in ("src", "pdf", "pages"))
VARIANTS = {"1p": "VarunMehrishi_Resume_1p", "2p": "VarunMehrishi_Resume_2p"}
# Public download names; deliberately different from the local application PDFs, which keep contact details.
PUBLIC_NAMES = {"1p": "Varun_Mehrishi_Resume_1_page.pdf", "2p": "Varun_Mehrishi_Resume_2_pages.pdf"}


def compile_cli(src, fmt, out):
    subprocess.run(["typst", "compile", "--root", SRC, "--input", "web=1", "--format", fmt, src, out], check=True)


def compile_py(src, fmt):
    lib = os.environ.get("TYPST_PY_LIB")
    if lib:
        sys.path.insert(0, lib)
    import typst  # noqa: E402
    result = typst.compile(src, root=SRC, format=fmt, sys_inputs={"web": "1"})
    return result if isinstance(result, list) else [result]


def main():
    for d in (PDF, PAGES):
        shutil.rmtree(d, ignore_errors=True)
        os.makedirs(d)
    use_cli = shutil.which("typst") is not None
    manifest = {}
    for key, name in VARIANTS.items():
        src = os.path.join(SRC, name + ".typ")
        pdf_out = os.path.join(PDF, PUBLIC_NAMES[key])
        if use_cli:
            compile_cli(src, "pdf", pdf_out)
            compile_cli(src, "svg", os.path.join(PAGES, f"{key}-{{n}}.svg"))
            pages = sorted(f for f in os.listdir(PAGES) if f.startswith(key + "-"))
        else:
            open(pdf_out, "wb").write(compile_py(src, "pdf")[0])
            svgs = compile_py(src, "svg")
            pages = []
            for i, data in enumerate(svgs, 1):
                fn = f"{key}-{i}.svg"
                open(os.path.join(PAGES, fn), "wb").write(data)
                pages.append(fn)
        manifest[key] = {"pdf": f"pdf/{PUBLIC_NAMES[key]}", "pages": [f"pages/{p}" for p in pages],
                         "label": "One page" if key == "1p" else "Two pages"}
        print(f"{key}: {len(pages)} page(s), pdf {os.path.getsize(pdf_out)} bytes")
    json.dump(manifest, open(os.path.join(PAGES, "manifest.json"), "w"), indent=1)
    open(os.path.join(PAGES, "manifest.js"), "w").write("window.RESUME_MANIFEST = " + json.dumps(manifest) + ";\n")
    print("wrote pages/manifest.json via", "typst CLI" if use_cli else "typst python package")


if __name__ == "__main__":
    main()
