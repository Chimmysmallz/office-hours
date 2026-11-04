# Office Hours

A browser-based office life-sim and dating story. You have just joined Project Lighthouse at Meridian, a fictional company in an unnamed city. You have eleven weeks before the launch gala. Five colleagues, five storylines, twenty-six endings, and only three time slots a day to spend.

**Play it online:** [chimmysmallz.github.io/office-hours](https://chimmysmallz.github.io/office-hours/)

You can also open `index.html` in any modern browser. There is nothing to install and no internet connection is needed.

## Playing on a phone

Office Hours is built for phones first.

- **Hold your phone sideways.** The game plays in landscape and shows a reminder if the phone is upright.
- **iPhone (Safari):** for full screen without the browser bars, tap **Share**, then **Add to Home Screen**, and open the game from the new icon. It saves your progress in the same way.
- **Android (Chrome):** the game switches to full screen when you first tap the title screen.
- Everything is tap-only: tap people and objects to interact, and tap the text box to move the conversation on. Pop-up panels keep their buttons on screen, so there is no scrolling to find **Next** or **Start**.

---

## What is in the game

- **Five romance routes.** Zara (trust and vulnerability), Priya (enemies to lovers), Noah (a hidden slow burn), Marcus (crossing professional lines) and Kai (work-life balance). Each has its own scenes and four endings. Every route now runs to roughly 2,400 to 3,900 words.
- **One shared timeline.** The five stories happen in the same office in the same quarter. The Lighthouse lead role is offered once, and whatever you decide, everyone reacts to it. Get close to two people at once and the office starts to talk. At the gala you choose who to walk across the room to, and the others notice.
- **Choices that come back.** Promises, betrayals and small kindnesses are remembered and paid off later, sometimes weeks later.
- **Seven career endings**, including "Have It All" (career, reputation, love, and standing up to Vaughn), the middle-ground "A Seat at the Table", and three bad endings to avoid: Burnout, Pariah and Outplayed. Twenty-seven endings in total.
- **Activities with decisions.** Every activity is a small choice or mini-game: sort your inbox under pressure, build a three-slide pitch, choose who to sit with at lunch, decide what goes first in the sprint, plus the dance-off rhythm game at the stereo.
- **Eight player characters** to choose from, all drawn in the same style as the cast.
- **Four rooms** in the Meridian tower: the ninth-floor office, the meeting room, the ground-floor café and the rooftop terrace. A tower map with a working lift moves you between them.
- **Character schedules.** Colleagues move between rooms through the day. A pink **!** means someone has a new story moment waiting.
- **Three meters.** Energy, Career and Reputation, shown as rings that pulse red when you are in danger. Repeating the same activity earns less, and the top of each meter takes real effort to reach.
- **Eighteen random office events**, from printer jams to fire drills, plus rumours that react to your love life.
- **An orientation guide** in which the cast teaches you the game, with small interactive demos.
- **Quality of life:** text speed, skip for lines already read, auto-advance, a conversation log, autosave every evening and three manual save slots.
- **An endings gallery** that persists across playthroughs, with hints for locked endings.
- **An original soundtrack.** Four short pieces, one per room, composed for the game and played by instruments built into the page, plus a theme for each character and office ambience.

In numbers: 119 scenes, about 20,000 words of dialogue (around 90 minutes of reading per full set of routes) and 254 player choices.

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

The `godot/` folder holds the original Godot 4 starter project. It includes the art and an earlier version of the story files. The newest story files in `web/story/` use features the Godot code does not understand yet (shared-timeline branches), so they have not been copied across. The Godot code has also not been updated with the newer features of the web version: the Marcus and Kai routes, the extra rooms, the office events, the orientation guide, the tower map and the endings gallery. Open `godot/project.godot` in Godot 4.3 or newer to run it. Instructions for adding the art are in `godot/ASSETS_GUIDE.md`.

---

## Credits

Created by Chiamaka Nwabulue. Story, design and art were produced with the help of Microsoft Copilot.
