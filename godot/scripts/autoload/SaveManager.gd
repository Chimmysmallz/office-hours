extends Node
## Autoload: SaveManager — minimal save/load of GameState to user://.
## Not wired to any button yet; call SaveManager.save_game() / load_game() when you want it.

const PATH := "user://save.json"


func save_game() -> void:
	var data := {
		"affection": GameState.affection,
		"reputation": GameState.reputation,
		"career": GameState.career,
		"energy": GameState.energy,
		"week": GameState.week,
		"day": GameState.day,
		"slot": GameState.slot,
		"flags": GameState.flags,
		"locked_route": GameState.locked_route,
	}
	var f := FileAccess.open(PATH, FileAccess.WRITE)
	f.store_string(JSON.stringify(data))
	f.close()


func load_game() -> bool:
	if not FileAccess.file_exists(PATH):
		return false
	var text := FileAccess.get_file_as_string(PATH)
	var data = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		return false
	GameState.affection = data.get("affection", GameState.affection)
	GameState.reputation = int(data.get("reputation", 0))
	GameState.career = int(data.get("career", 0))
	GameState.energy = int(data.get("energy", 100))
	GameState.week = int(data.get("week", 1))
	GameState.day = int(data.get("day", 1))
	GameState.slot = data.get("slot", "morning")
	GameState.flags = data.get("flags", {})
	GameState.locked_route = data.get("locked_route", "")
	return true
