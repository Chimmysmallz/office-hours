# Office Hours

A browser-based office life-sim and dating story. You have just joined Project Lighthouse at Meridian, a fictional company in an unnamed city. You have eleven weeks before the launch gala. Five colleagues, five storylines, twenty-six endings, and only three time slots a day to spend.

**Play it:** open `index.html` in any modern browser on desktop or mobile. There is nothing to install and no internet connection is needed.

---

## What is in the game

- **Five romance routes.** Zara (trust and vulnerability), Priya (enemies to lovers), Noah (a hidden slow burn), Marcus (crossing professional lines) and Kai (work-life balance). Each has its own scenes and four endings.
- **Six career endings**, including a rare "Have It All", and three bad endings to avoid: Burnout, Pariah and Outplayed.
- **Four rooms** in the Meridian tower: the ninth-floor office, the meeting room, the ground-floor café and the rooftop terrace. A tower map with a working lift moves you between them.
- **Character schedules.** Colleagues move between rooms through the day. A pink **!** means someone has a new story moment waiting.
- **Three meters.** Energy, Career and Reputation, shown as rings that pulse red when you are in danger. Repeating the same activity earns less each time.
- **Sixteen random office events**, from printer jams to fire drills, each a quick choice with a trade-off.
- **A dance-off rhythm game** at the office stereo.
- **An orientation guide** in which the cast teaches you the game, with small interactive demos.
- **Quality of life:** text speed, skip for lines already read, auto-advance, a conversation log, autosave every evening and three manual save slots.
- **An endings gallery** that persists across playthroughs, with hints for locked endings.
- **Sound** generated in the browser: room music, character themes, office ambience and effects.

---

## Repository layout

```
index.html            The finished game. One self-contained file. Open this to play.
web/                  Source for index.html
  build.py            Rebuilds index.html from the files below (Python 3.8+, no extra packages)
  template.html       Game engine, layout and styles
  story/*.json        Every conversation, one file per route plus career endings
  data/events.json    Random office events
  data/endings.json   Rules for the career endings
  assets/*.webp       Compressed art used by the web build
art/originals/        Full-size originals of the art added for the web version
godot/                The original Godot 4 starter project (see the note below)
SECURITY.md           Security and privacy review
```

---

## Editing the game

1. Edit a file in `web/`. Most writing changes happen in `web/story/*.json`.
2. From inside the `web` folder, run:

   ```
   python build.py
   ```

3. Open `index.html` to test your change.

The build script checks that every conversation link points to a line that exists. If something is broken, it names the scene and line instead of building a faulty game.

### How a story scene is structured

Each scene has a `start` line and a set of `nodes`. A node either shows a line of text and moves to `next`, or offers `choices`. Choices can change affection, meters and story flags through `effects`:

```json
"c1": { "speaker": "You", "choices": [
  { "text": "'Sit with him.'", "effects": { "affection_noah": 6, "set_flags": ["noah_bond"] }, "next": "sit" }
]}
```

A node marked `"terminal": true` ends the scene. A node can use `variants` to show different text depending on an earlier choice.

---

## Publishing with GitHub Pages

Because the game is a single `index.html` at the top of the repository, GitHub Pages can host it with no extra setup:

1. On GitHub, open the repository, then **Settings → Pages**.
2. Under **Build and deployment**, choose **Deploy from a branch**, select `main` and `/ (root)`, then **Save**.
3. Tick **Enforce HTTPS** once the option appears.

After a minute or two, the game is live at `https://<your-username>.github.io/<repository-name>/`.

---

## Privacy

The game has no accounts, no analytics, no cookies, no ads and no network connections. The player's name, saves, settings and endings gallery are stored only in the browser on that device. Players can wipe all of it from **Menu → Settings → Delete all my game data**. Full details are in `SECURITY.md`.

## Content guidance

Suitable for ages 13 and up. Mild workplace romance (a few kisses, nothing explicit), occasional mild language and office politics. There is no violence, gambling or drug use.

---

## About the Godot version

The `godot/` folder holds the original Godot 4 starter project. It now includes the new Marcus and Kai story files, the office events and the new art, so the content is ready. However, the Godot code has not yet been updated with the newer features of the web version: the Marcus and Kai routes, the extra rooms, the office events, the orientation guide, the tower map and the endings gallery. Open `godot/project.godot` in Godot 4.3 or newer to run it. Instructions for adding the art are in `godot/ASSETS_GUIDE.md`.

---

## Credits

Created by Chiamaka Nwabulue. Story, design and art were produced with the help of Microsoft Copilot.
