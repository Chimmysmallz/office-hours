# Security and privacy review

**Reviewed:** 28 October 2026
**Scope:** `index.html`, the `web/` source and build script, and the `godot/` project in this repository.

## Summary

Office Hours is a single-player game that runs entirely in the player's browser. It has no server, no database, no accounts, no logins, no payments, no file uploads, no email collection and no third-party code. It never makes a network connection. Most items on common launch checklists apply to apps with those parts, so they do not apply here. The items that do apply were checked, and where needed, fixed.

## What the game stores

| Data | Where | Why | Leaves the device? |
|---|---|---|---|
| The name the player types | Browser local storage | Shown in dialogue and on the end screen | No |
| Save games (meters, story progress) | Browser local storage | Continue and load | No |
| Settings (text speed, volume) | Browser local storage | Remember preferences | No |
| Endings unlocked and lines already read | Browser local storage | Gallery and skip feature | No |

Players can delete all of it at any time from **Menu → Settings → Delete all my game data**. This removes only Office Hours data and leaves other sites' data alone.

**Hosting note:** if the game is published on GitHub Pages, GitHub (as the web host) receives visitors' IP addresses in its server logs, as any web host does. That is covered by GitHub's own privacy statement. The game itself sends nothing.

## Launch checklist

| # | Item | Status | Notes |
|---|---|---|---|
| 1 | Hide API keys | ✅ Not applicable | The game uses no APIs and contains no keys. |
| 2 | Purge Git secrets | ✅ Clean | All files were scanned for keys, tokens and passwords; only story dialogue matched the word "secret". A `.gitignore` blocks `.env` and key files. This review covers these files, not the earlier commit history of your existing repository. |
| 3 | Use public DB key | ✅ Not applicable | No database. |
| 4 | Enable row-level security | ✅ Not applicable | No database. |
| 5 | Encrypt sensitive data | ✅ Not applicable | No sensitive data is collected. Saves hold a first name and game progress, on the player's own device only. |
| 6 | Enforce server-side auth | ✅ Not applicable | No server and no accounts. |
| 7 | Lock record access | ✅ Not applicable | Each browser keeps its own saves; there are no shared records. |
| 8 | Block field tampering | ✅ Done | Players could hand-edit their own saves. Every saved field is now checked on load: numbers are range-limited, rooms, images, scenes and events must be real entries, and unknown fields are dropped. Tested with a deliberately corrupted save, including attempts to inject HTML and to target `__proto__`. |
| 9 | Secure session cookies | ✅ Not applicable | The game sets no cookies. |
| 10 | Hash passwords | ✅ Not applicable | No passwords. |
| 11 | Rate limit login | ✅ Not applicable | No login. |
| 12 | Add bot protection | ✅ Not applicable | No forms or server endpoints to abuse. |
| 13 | Parameterize queries | ✅ Not applicable | No database queries. |
| 14 | Validate all input | ✅ Done | The only typed input is the player's name. It is limited to 18 characters, and control characters and `<` `>` are stripped. |
| 15 | Escape user content | ✅ Done | The name is escaped wherever it is shown. Dialogue text is inserted as plain text, never as HTML. The build script also escapes `</` in embedded data so story text can never break out of the script block. |
| 16 | Restrict file uploads | ✅ Not applicable | No uploads. |
| 17 | Trim API responses | ✅ Not applicable | No API. |
| 18 | Add security headers | ⚠️ Partly | A Content Security Policy is built into the page. It blocks all network connections, external scripts, fonts, frames and form submissions, and a no-referrer policy is set. GitHub Pages does not allow custom server headers, so clickjacking protection (`frame-ancestors`) cannot be added. The risk is low because the game has no account or payment actions to hijack. |
| 19 | Force HTTPS | ⚠️ One setting | Tick **Enforce HTTPS** in the repository's Pages settings when you publish. |
| 20 | Scan dependencies | ✅ None to scan | No npm packages, no CDN libraries, no Godot plugins. The build script uses only the Python standard library. |

## Privacy and compliance checklist (NDPA / NDPC)

| # | Concern | Status | Notes |
|---|---|---|---|
| 1 | No age check | ✅ Not required | No personal data is collected or sent anywhere, so there is no data processing to gate. The content is mild, and the README recommends ages 13 and up. |
| 2 | Google Fonts leaking IP | ✅ None | The game uses the device's own fonts. The security policy blocks web fonts from loading at all. |
| 3 | Hotjar recording passwords | ✅ None | No analytics, heatmaps or session recording of any kind. |
| 4 | Waitlist email with no unsubscribe | ✅ Not applicable | No email collection. |
| 5 | Paystack button with no renewal terms | ✅ Not applicable | No payments. |
| 6 | Profile pictures as biometric data | ✅ Not applicable | No photos, camera access or uploads. The player character is pre-drawn art. |
| 7 | No cookie banner | ✅ Not required | No cookies and no tracking. Local storage holds only what the game needs to work, stays on the device, and can be deleted in one tap. A plain-language privacy note is shown in Settings and on the new-game screen. |

This review is a technical assessment, not legal advice. If the game is later sold, adds accounts, analytics, ads or payments, or collects email addresses, review it again before launch and consider advice from a data protection professional.

## How this was checked

- Automated scan of every file for external URLs, network APIs (`fetch`, `XMLHttpRequest`, `WebSocket`, `sendBeacon`), cookies, `eval`, inline event handlers and secret-like strings.
- Automated tests covering every screen, every story route through to its endings, a corrupted save file, and the delete-my-data button.
- Validation of `index.html` as a self-contained page with no external references.
- A review of the Godot project for network code (none found; it saves locally to the player's device).
