# Meridian4D

A charter fleet register for macOS, written in 4D. Navigation sidebar, sortable register and
detail inspector, styled to current macOS platform conventions.

## Requirements

| | |
|---|---|
| 4D | v21 R4 or later, **project mode** |
| macOS | 26 Tahoe or Golden Gate |
| Component | 4D SVG, declared in `Project/Sources/dependencies.json` and resolved when the project opens |

## macOS only

This project targets macOS and no other platform.

Appearance comes from `Project/Sources/styleSheets_mac.css`. 4D applies a `_mac` style sheet on
macOS only, so the window renders unstyled anywhere else.

Rendering on Windows 11 was considered and placed deliberately out of scope. The layout, the
materials and the window chrome all follow macOS conventions that have no Windows equivalent.

## Running it

Open the project. The menu bar installs itself and the launcher appears. Close the launcher to use the menu bar

- **Meridian > New Fleet Window** opens a register in its own process. Several may be open at once.
- **Meridian > Activity Log** shows what the application has recorded.
- **Meridian > Quit Meridian** closes every Meridian window and leaves 4D running.
- **Meridian > Open Project** available in the menu bar, it opens the project in design mode.

## Data

The fleet lives in `Data/fleet.json` and the activity log in `Data/log.json`. Both are plain
JSON and both are rewritten by the application.