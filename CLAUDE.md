# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repository is

This is **course material**, not a software product: a French-language beginner course teaching **GitHub Copilot CLI**, structured as chapters `00`–`08` (each a directory with a `README.md` and `assets/`). See `AGENTS.md` for the full chapter map and `.github/copilot-instructions.md` for detailed writing conventions — both are load-bearing and should be read before making non-trivial content changes.

## Commands

```bash
npm install && npm run release   # generate:demos: create VHS tapes, render demo GIFs, verify them
npm run generate:headers         # regenerate chapter header images (Python script)
npm run scan:demos               # scan chapters for `copilot` command blocks needing demo GIFs
npm run release:ci               # CI-only: headers regeneration
```

Sample app tests (each variant is independent, run from its own directory):

```bash
cd samples/book-app-project    && python -m pytest tests/
cd samples/book-app-project-js && npm test
cd samples/book-app-project-cs && dotnet test
```

## Architecture / content model

- **Chapters (`00-08/README.md`)** are the actual course content. Every chapter follows the fixed structure: real-world analogy → core concepts → hands-on examples → exercise → what's next. Don't deviate from this structure when editing a chapter.
- **`samples/book-app-project/`** (Python) is the single running example used across chapters — CLI book-collection app (`book_app.py`, `books.py`, `utils.py`, `data.json`, `tests/test_books.py`). It is intentionally imperfect (weak validation, thin tests) so it can be improved live with Copilot CLI during the course. `-js` and `-cs` are parallel ports of the same app for language-specific chapters.
- **`samples/book-app-buggy/`** and **`samples/buggy-code/`** contain **intentional bugs** for debugging exercises — never fix them, and never update their tests when bugs are added there.
- **`samples/agents/`** / **`.github/agents/`** and **`samples/skills/`** / **`.github/skills/`** hold example Copilot agent (`.agent.md`) and skill (`SKILL.md`) templates referenced by chapters 05 and 06 respectively. Changes to one side (`.github/`) generally need mirroring to the other (`samples/`) since chapters reference the `samples/` copies as the reader-facing example.
- **`samples/mcp-configs/`** holds example MCP server configs referenced by chapter 07.
- **`samples/src/`** is legacy/optional JS-React material from a previous course version — not part of the main teaching path.
- **`.github/scripts/`** are Node/Python build tooling for demo GIF generation (via VHS `.tape` files) and translation sync — not app code.
- **`GLOSSARY.md`** defines terms alphabetically; new terminology introduced in a chapter should be added there.
- **`appendices/`** holds supplementary reference docs (CI/CD integration, additional context) not part of the numbered chapter sequence.

## Content conventions (from `.github/copilot-instructions.md`)

- Audience is AI/ML beginners — define jargon on first use; friendly, encouraging, practical tone.
- All `copilot` command blocks must be copy-paste ready; use `kebab-case` for session names, files, and identifiers; standardize flags as `--flag=value` (with value) / `--flag` (boolean).
- Don't over-specify behavior that varies by shell/OS — describe what the user sees, not implementation details.
- When citing a minimum tool version, always give an upgrade path or manual fallback.
- Multi-step workflows must include prerequisite steps (e.g. `git add` before `git diff --staged`).
- Images go in `assets/` at repo root or the chapter's own `assets/`; use relative links for cross-chapter references.

## Maintenance matrix

When changing something, update the paired files (full table in `.github/copilot-instructions.md`):

| Change | Also update |
|---|---|
| New chapter | `README.md` course table, `AGENTS.md` structure table, `assets/learning-path.png` |
| Sample app code changed | `samples/book-app-project/tests/`, chapters referencing that code |
| Bug added to buggy samples | Only the buggy file itself — **not** tests |
| New skill / agent / MCP config | `.github/skills/`+`samples/skills/` (or `samples/agents/`, `samples/mcp-configs/`) and the relevant chapter (06 / 05 / 07) |
| New glossary term | `GLOSSARY.md`, alphabetically |
| npm scripts changed | `package.json`, `AGENTS.md` build section |

## PR policy

The repo does **not** accept PRs that modify existing sample app code (`samples/book-app-project*`, buggy samples) — that code is deliberately shaped to produce specific outputs during review/debugging demos in the course.
