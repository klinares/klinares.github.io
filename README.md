# klinares.github.io

Source for [klinares.github.io](https://klinares.github.io), built with Quarto 1.5.

```
_quarto.yml                  site config: navbar, footer, theme, what gets rendered/copied
index.qmd                    portfolio (about, skills, projects by group)
coursework.qmd               graduate coursework, one listing per semester
404.qmd                      not-found page
methods.html                 interactive TSE atlas: self-contained, copied as-is
courses/                     per-course reference summaries + syllabi, copied as-is
data/projects.yml            every project card AND the profile README badges
data/courses.yml             every course card
_templates/*.ejs             card markup for the two listings
assets/theme.scss            the design system (palette, type, hairline cards)
assets/favicon.svg
R/build_profile_readme.R     writes ../klinares/README.md from data/projects.yml
.github/workflows/publish.yml  render + deploy to GitHub Pages on push to main
```

## Everyday edits

- **Add or change a project:** edit `data/projects.yml`. Give it a `badge:` to also show it on the GitHub profile.
- **Preview:** `quarto preview`
- **Update the GitHub profile README:** `Rscript R/build_profile_readme.R --dry-run`, then without `--dry-run`; commit and push in `../klinares`.
- **Publish:** push to `main`; the workflow renders and deploys.

## Notes

- `courses/` is about 590 MB and is copied into `_site/` on every render. GitHub Pages sites are limited to 1 GB.
- Syllabus links use absolute `github.com/.../blob/...` URLs because GitHub Pages returns 403 on directory paths.
- SURV 772 on the transcript is the UMich design seminar; its folder is `courses/design_seminar_SURV670`.
- `methods.html` keeps its own copy of the palette; if the palette changes in `assets/theme.scss`, update its `:root` block too.
