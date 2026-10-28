extends Node
## Autoload: GameState — the single source of truth for the whole game.
## Meters, story flags, and where you are in time all live here.

signal meter_changed(meter_name: String, value: int)
signal flag_set(flag: String)

# --- Meters ---
var affection := {"zara": 0, "marcus": 0, "priya": 0, "kai": 0, "noah": 0}
var reputation := 0
var career := 0
var energy := 100

# --- Story progression ---
var week := 1
var day := 1                      # 1-5 within a week
var slot := "morning"             # morning / lunch / afternoon / after_work
var flags := {}                   # e.g. { "zara_wall_revealed": true }
var locked_route := ""            # set once the player commits to someone


func _ready() -> void:
	# Make sure 2D tap/click picking is on so tapping people and objects registers.
	get_viewport().physics_object_picking = true


func add_affection(who: String, amount: int) -> void:
	if not affection.has(who):
		return
	affection[who] = clampi(affection[who] + amount, 0, 100)
	meter_changed.emit("affection_" + who, affection[who])


func add_meter(meter: String, amount: int) -> void:
	match meter:
		"reputation": reputation = clampi(reputation + amount, 0, 100)
		"career":     career     = clampi(career + amount, 0, 100)
		"energy":     energy     = clampi(energy + amount, 0, 100)
	meter_changed.emit(meter, get(meter))


func set_flag(flag: String) -> void:
	flags[flag] = true
	flag_set.emit(flag)


func has_flag(flag: String) -> bool:
	return flags.get(flag, false)


## Apply an "effects" dictionary straight from a choice/node in JSON.
## Keys: "affection_<who>", "reputation", "career", "energy", or "set_flags".
func apply_effects(effects: Dictionary) -> void:
	for key in effects:
		if key.begins_with("affection_"):
			add_affection(key.trim_prefix("affection_"), effects[key])
		elif key in ["reputation", "career", "energy"]:
			add_meter(key, effects[key])
		elif key == "set_flags":
			for f in effects[key]:
				set_flag(f)
