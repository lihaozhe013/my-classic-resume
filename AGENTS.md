# Project Instructions

## Content and language policy

- The English resume in the repository root is the canonical source of truth.
- Keep every other language version, currently `cn/`, semantically aligned with the latest English version. When the English version changes, update the corresponding translated sections in the same change.
- Preserve all facts consistently across language versions, including dates, organizations, roles, project names, skills, technologies, links, and descriptions.
- Do not translate technical terms, proper nouns, product names, company names, organization names, or other terminology. Keep these terms in English in every language version.

## Formatting and validation

- Before every commit, run:

  ```sh
  make format
  ```

- Review the formatting diff before committing. The formatter applies to all `.tex` files in the repository.
- When validating generated resumes, use `make all` for the English version and `make cn` for the Chinese version when the required LaTeX toolchain is available.

## Project structure

```text
.
├── resume.tex                 # English resume entry point
├── resume/                    # English resume sections
│   ├── heading.tex
│   ├── education.tex
│   ├── technical-skills.tex
│   ├── experience.tex
│   └── projects.tex
├── cn/
│   ├── resume.tex             # Chinese resume entry point
│   ├── awesome-cv.cls         # LaTeX document class used by the Chinese version
│   ├── LICENCE
│   └── resume/                 # Chinese resume sections
│       ├── heading.tex
│       ├── education.tex
│       ├── technical-skills.tex
│       ├── experience.tex
│       └── projects.tex
├── Makefile                   # Formatting, compilation, and cleanup targets
├── format.py                  # Formats all LaTeX source files
└── indentconfig.yaml          # Configuration for LaTeX formatting
```

The root `resume.tex` imports content from `resume/`. The Chinese entry point `cn/resume.tex` imports content from `cn/resume/`. Keep the corresponding section files structurally comparable so that updates can be synchronized reliably.
