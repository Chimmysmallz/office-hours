# Office Hours — Godot 4 Starter

A runnable skeleton for an office-set dating-sim / life-sim. The whole architecture
is here: a click-to-move animated avatar with a state machine, a data-driven dialogue
system, meters, and time progression. **The story lives in JSON — the engine just reads it.**

Everything you see on screen right now uses colored-square placeholders so it runs with
zero art assets. Swap in real sprites later without changing the game logic.

## How to run

1. Install **Godot 4.3 or newer** (free, from godotengine.org).
2. Open Godot → **Import** → select the `project.godot` file in this folder.
3. Press **Play** (F5).

(You can also copy the contents of this folder into an existing empty Godot 4 project.)

## What to try

- **Click the brown "Coffee" square** → your avatar walks over, "eats," and Energy goes up.
- **Click "Desk" (work)** → Career up, Energy down.
- **Click "Stereo" (dance)** → Reputation up.
- **Click "Zara" (talk)** → a branching dialogue plays; your choices change the meters
  (watch the top-left HUD) and set story flags.
- **Click "End time slot"** (top-left) → advances Morning → Lunch → ... → next day/week.
- **Click "Exit"** → reloads the room (your meters persist — that's the autoload state).

The avatar changes color per state (blue = idle, green = walking, and a different tint
while eating/dancing/working/chatting) so you can *see* the state machine working.

## How it's organized

```
scripts/autoload/    GameState, DialogueManager, SceneRouter, SaveManager  (global singletons)
scripts/characters/  Avatar.gd + states/ (the state machine)
scripts/rooms/       Hotspot.gd (clickable objects)
scripts/ui/          MeterHUD.gd, DialogueBox.gd (built in code)
scenes/              Main.tscn (the room), characters/Avatar.tscn
data/story/          your dialogue scenes as JSON  <-- add content here
data/                characters.json, endings.json (config)
```

## Extending it (no engine changes needed)

- **New conversation:** add a scene object to any file in `data/story/`, then point a
  "talk" hotspot's `dialogue_id` at it.
- **New clickable action:** duplicate a Hotspot node in `Main.tscn`, set its `action`,
  `animation`, `stand_marker`, and `effects` in the Inspector.
- **New room:** duplicate `Main.tscn`, and give an "Exit" hotspot `travel_to` = the new
  scene's path.
- **Real animations:** replace the placeholder `Body` square in `Avatar.tscn` with an
  `AnimatedSprite2D`, then in `ActionState.gd` swap the timer for
  `sprite.play(hotspot.animation)` + `await sprite.animation_finished`.

## Notes

- The "Vaughn's been circling you too" choice is intentionally hidden until the
  `met_vaughn` flag is set — it demonstrates flag-gated choices. Set it in the editor
  (or add a scene that sets it) to see it appear.
- Story JSON is read straight from disk when you run in the editor. If you later
  **export** the game, add `*.json` to the export's non-resource file filters so the
  files ship with the build.
