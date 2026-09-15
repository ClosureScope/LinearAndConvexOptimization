<div align="center">

# Course Name

课程中文名 · `COURSE0000` · SJTU

**Author Closure**

[![Auto Release](https://github.com/ClosureScope/NotesTemplate/actions/workflows/auto_release.yml/badge.svg)](https://github.com/ClosureScope/NotesTemplate/actions/workflows/auto_release.yml)
[![Latest PDF](https://img.shields.io/badge/download-latest%20PDF-red)](https://github.com/ClosureScope/NotesTemplate/releases/latest)
[![Made with Typst](https://img.shields.io/badge/made%20with-Typst-239dad)](https://typst.app/)

</div>

---

Course notes for **Course Name（课程中文名, `COURSE0000`）** at **SJTU**,
typeset in [Typst](https://typst.app/) and continuously built into a PDF by CI.

## Download

The latest PDF is built automatically on every push and published to
[**Releases → latest**](https://github.com/ClosureScope/NotesTemplate/releases/latest). No need to clone or compile anything.

## Repository layout

| File | Description |
|------|-------------|
| [`notebook.typ`](notebook.typ) | Source of the notes, written in Typst |
| [`template.typ`](template.typ) | Styling template (imported by the notes, not compiled on its own) |
| [`course.toml`](course.toml) | Course metadata — the single source of truth for this README and the release workflow |
| `*.pdf` | Compiled output — built by CI, get it from [Releases](https://github.com/ClosureScope/NotesTemplate/releases/latest) |

## Building locally

```bash
typst compile notebook.typ
```

---

<div align="center">
<sub>README is generated from <code>course.toml</code> — edit the TOML, not this file. CI logic lives in <a href="https://github.com/ClosureScope/NotesCI">NotesCI</a>.</sub>
</div>
