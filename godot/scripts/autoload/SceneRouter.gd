extends Node
## Autoload: SceneRouter — handles room changes and the passage of time.

const SLOTS := ["morning", "lunch", "afternoon", "after_work"]


func change_room(scene_path: String) -> void:
	if scene_path == "":
		return
	get_tree().change_scene_to_file(scene_path)


func advance_slot() -> void:
	GameState.add_meter("energy", -10)   # time costs energy
	var i := SLOTS.find(GameState.slot)
	if i + 1 < SLOTS.size():
		GameState.slot = SLOTS[i + 1]
	else:
		GameState.slot = SLOTS[0]
		GameState.day += 1
		if GameState.day > 5:
			GameState.day = 1
			GameState.week += 1
	_check_scheduled_events()


func _check_scheduled_events() -> void:
	# Example hook: at the end of week 12, jump to the finale scene.
	# if GameState.week == 12 and GameState.slot == "after_work":
	#     change_room("res://scenes/rooms/GalaVenue.tscn")
	print("[time] Week %d, Day %d, %s" % [GameState.week, GameState.day, GameState.slot])
