# Build the GitHub profile README (klinares/klinares) from data/projects.yml.
#
# Every project with a `badge:` entry becomes a shields.io badge, ordered by badge$order.
# Run from the klinares.github.io repo root:
#
#   Rscript R/build_profile_readme.R                 # writes ../klinares/README.md
#   Rscript R/build_profile_readme.R --dry-run       # prints, writes nothing
#   Rscript R/build_profile_readme.R path/to/README.md
#
# shields.io static badges: "-" separates label/message/colour, so literal
# dashes are doubled and spaces/specials are URL-encoded.

library(yaml)
library(purrr)
library(glue)

args    <- commandArgs(trailingOnly = TRUE)
dry_run <- "--dry-run" %in% args
out     <- discard(args, \(a) a == "--dry-run") |>
  pluck(1, .default = file.path("..", "klinares", "README.md"))

projects <- read_yaml("data/projects.yml", fileEncoding = "UTF-8")
template <- readLines("R/profile_readme_template.md", encoding = "UTF-8") |>
  paste(collapse = "\n")

shields_escape <- function(x) {
  x |>
    gsub(pattern = "-", replacement = "--", fixed = TRUE) |>
    gsub(pattern = "_", replacement = "__", fixed = TRUE) |>
    URLencode(reserved = TRUE)
}

badge_md <- function(p) {
  alt <- sub(" · .*$", "", p$badge$text)
  glue(
    "[![{alt}](https://img.shields.io/badge/{shields_escape(p$badge$text)}-{p$badge$color}",
    "?style=for-the-badge&labelColor=0f1f38&logo=r&logoColor=a8c4d8)]({p$repo})"
  )
}

badges <- projects |>
  keep(\(p) !is.null(p$badge)) |>
  (\(ps) ps[order(map_dbl(ps, \(p) p$badge$order %||% Inf))])() |>
  map_chr(badge_md) |>
  paste(collapse = "\n\n")

readme <- sub("{{badges}}", badges, template, fixed = TRUE)

if (dry_run) {
  cat(readme, "\n")
} else {
  if (!dir.exists(dirname(out))) stop("Profile repo not found at ", dirname(out))
  writeLines(readme, out, useBytes = TRUE)
  message("Wrote ", normalizePath(out), " (", length(gregexpr("img.shields.io", badges)[[1]]), " project badges)")
}
