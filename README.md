# The Yoyo Archive — Open Dataset

Structured, open data from [The Yoyo Archive](https://yoyoarchive.org): an archival reference for yoyo history — products, companies, player profiles, reviews, competitions, catalogs, articles and stories.

Licensed under **CC BY-SA 4.0** (see `LICENSE`).

**Last update:** 2026-10-06

## Attribution (required)

Credit **The Yoyo Archive** (<https://yoyoarchive.org>) and link back. Derivatives must be shared under CC BY-SA 4.0.

Suggested credit: `Data from The Yoyo Archive (https://yoyoarchive.org), CC BY-SA 4.0.` See `CITATION.cff` for citation metadata.

## Files

| File | Contents |
|---|---|
| `data/product.json` | Yo-yo models with specs |
| `data/company.json` | Manufacturers and brands |
| `data/profile.json` | Player profiles |
| `data/review.json` | Reviews |
| `data/competition.json` | Competition records |
| `data/catalog.json` | Manufacturer catalogs (metadata + file pointers) |
| `data/article.json` | Long-form articles |
| `data/story.json` | Stories |
| `data/media.json` | Media items |
| `data/taxonomies.json` | Categories, materials, play styles, media types |
| `data/manifest.json` | Record counts per type |

Each file is a JSON array sorted by `slug`. Schema: `schema/record.schema.json`.

## Record fields

| Field | Meaning |
|---|---|
| `id` | WordPress post ID on yoyoarchive.org |
| `slug`, `url` | Slug and canonical page |
| `type` | `product`, `company`, `catalog`, `competition`, `article`, `story`, `review`, `profile`, `yya_media` |
| `title` | Title |
| `date_modified` | Last modified (UTC date) |
| `content` | Plain text of the body (no HTML) |
| `folio` | Archive folio number, when assigned |
| `meta` | Type-specific fields, keys prefixed `yya_` |
| `terms` | Taxonomy slugs, keyed by taxonomy |
| `relations` | Linked published records (`slug`, `url`, `title`), keyed by field, e.g. `yya_company` |

## What is not included

- Drafts and unpublished records.
- Images and catalog PDFs. `yya_gallery_images` and `yya_files` hold pointers (`url`, `title`, `type`) only; the files remain with their owners.
- Story text. `data/story.json` keeps metadata and source citations (`yya_story_source_label`, `yya_story_source_url`) but `content` is empty, because stories quote third-party material.
- User accounts, and email addresses (redacted as `[email removed]`).

## Corrections

Open an issue or pull request. Data is regenerated from the live archive, so accepted corrections are applied there and flow back into the next release.

## Validation

CI validates every file against the schema and runs `scripts/guard.sh` (no emails, no non-published markers, no secrets).
