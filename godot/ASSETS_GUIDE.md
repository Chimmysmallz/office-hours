# Dropping the art into Godot

All seven PNGs are already in this project under **`assets/sprites/`**, so when you
open the project in Godot they'll show up in the FileSystem dock, ready to drag.

## What goes where

| Art file | Replaces the placeholder on… | Suggested Scale |
|----------|------------------------------|-----------------|
| `office-background.png` | the `Background` node in **Main.tscn** | `0.75, 0.75` |
| `avatar-player.png` | the `Body` square in **Avatar.tscn** | `0.07, 0.07` |
| `npc-zara.png` | the `Vis` square under `Hotspots/ZaraNPC` in **Main.tscn** | `0.09, 0.09` |
| `obj-coffee.png` | the `Vis` square under `Hotspots/CoffeeMachine` | `0.09, 0.09` |
| `obj-desk.png` | the `Vis` square under `Hotspots/Desk` | `0.09, 0.09` |
| `obj-stereo.png` | the `Vis` square under `Hotspots/Stereo` | `0.09, 0.09` |
| `obj-door.png` | the `Vis` square under `Hotspots/ExitDoor` | `0.09, 0.09` |

(Scales are starting points — nudge them until it looks right. The source images
are ~1024px, so the scale shrinks them down to game size.)

## The general recipe (works for every object)

For each hotspot (Coffee, Desk, Stereo, Zara, Door):

1. Open **Main.tscn**. In the Scene dock (top-left), expand `Hotspots`, then the object
   (e.g. `CoffeeMachine`).
2. Click its child `Vis` (the colored square) and press **Delete**.
3. Right-click the object node (`CoffeeMachine`) → **Add Child Node** → choose **Sprite2D**.
4. Select the new **Sprite2D**. In the **FileSystem** dock open `assets/sprites`, then
   drag the matching PNG onto the **Texture** slot in the Inspector (top-right).
5. Still in the Inspector, open **Transform → Scale** and set it (e.g. `0.09, 0.09`).
6. Optional: delete the little `Tag` label once you don't need it.

## The background (do this one slightly differently)

1. In **Main.tscn**, click the `Background` node (the gray Polygon2D) → **Delete**.
2. Right-click the root `Main` node → **Add Child Node** → **Sprite2D**. Rename it `Background`.
3. In the Scene dock, **drag it to the very top** of the list (2D draws top-to-bottom,
   so the first child sits behind everything).
4. Drag `office-background.png` onto its **Texture**.
5. Set **Position** = `576, 324` and **Scale** = `0.75, 0.75`.

## The avatar (in a separate scene)

1. Open **scenes/characters/Avatar.tscn**.
2. Delete the `Body` square.
3. Right-click the root `Avatar` node → **Add Child Node** → **Sprite2D**. Name it `Sprite`
   (anything **except** `Body`).
4. Drag `avatar-player.png` onto its **Texture**. Set **Scale** = `0.07, 0.07` and nudge
   **Position** so the feet sit around the node's center (try `0, -30`).

> Note: removing `Body` turns off the per-state color tinting (that was only for the
> placeholder square) — the code handles its absence safely, so nothing breaks. The
> floating action label ("walking", "eat...") still appears above the avatar.

### Optional: keep a state tint on the real sprite
If you want the avatar to still flash a color per action, open `scripts/characters/Avatar.gd`
and change `set_visual` to tint your sprite via `modulate` instead of `Body.color`:

```gdscript
func set_visual(color: Color, action_text: String = "") -> void:
	var sprite := get_node_or_null("Sprite")
	if sprite:
		sprite.modulate = color
	var label := get_node_or_null("Label")
	if label:
		label.text = action_text
```

Then press **Play (F5)** and your office comes to life.
