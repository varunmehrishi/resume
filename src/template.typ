// Shared ATS-friendly resume template (single column, real text, no tables/icons).
#let resume(name: "", title: "", contacts: (), paper: "a4", margin: 0.6in, size: 10.5pt, body) = {
  set document(title: name + " - Resume", author: name)
  set page(paper: paper, margin: margin)
  set text(font: ("Libertinus Serif", "DejaVu Serif"), size: size, ligatures: false, hyphenate: false, lang: "en")
  set par(justify: false, leading: 0.55em)
  // Keep hyphenated compounds and URLs on one line so text extractors never drop the hyphen.
  show regex("[A-Za-z0-9./]+(-[A-Za-z0-9./]+)+"): it => box(it)
  set list(marker: [•], indent: 0.6em, body-indent: 0.5em, spacing: 0.5em)
  show heading.where(level: 1): it => block(above: 0.95em, below: 0.5em)[
    #set text(size: size + 0.5pt, weight: "bold", tracking: 0.04em)
    #upper(it.body)
    #v(-0.45em)
    #line(length: 100%, stroke: 0.6pt)
  ]
  // Header: name, target title, one contact line (plain text URLs for parsers).
  align(center)[
    #text(size: size + 9.5pt, weight: "bold")[#name]
    #v(-0.35em)
    #text(size: size + 0.5pt)[#title]
    #v(-0.35em)
    #text(size: size - 1pt)[#contacts.map(c => box(c)).join([ #h(0.3em) | #h(0.3em) ])]
  ]
  v(0.2em)
  body
}

// Experience or project entry: title line with dates right-aligned, subtitle line, then bullets.
#let entry(title, dates, subtitle: none, body) = {
  block(above: 0.85em, below: 0.45em)[
    #text(weight: "bold")[#title] #h(1fr) #text(weight: "medium")[#dates]
    #if subtitle != none [ \ #emph(subtitle) ]
  ]
  body
}

// Compact one-line entry (education, early roles).
#let line-entry(left, right) = block(above: 0.6em, below: 0.3em)[#left #h(1fr) #right]

// Skills row: category label in bold followed by comma-separated keywords.
#let skills(..rows) = {
  for (label, items) in rows.pos() [
    #block(above: 0.55em, below: 0.55em)[*#label:* #items]
  ]
}
