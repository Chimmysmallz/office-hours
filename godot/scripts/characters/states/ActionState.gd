extends State
## Perform whatever the clicked hotspot asked for: eat / dance / work / talk / travel.

func enter(msg := {}) -> void:
	var hotspot = msg.get("hotspot", null)
	avatar.velocity = Vector2.ZERO
	if hotspot == null:
		machine.transition_to("IdleState")
		return

	match hotspot.action:
		"travel":
			SceneRouter.change_room(hotspot.travel_to)
		"talk":
			avatar.set_visual(Color(0.95, 0.75, 0.35), "chatting")
			if hotspot.dialogue_id.begins_with("@"):
				StoryDirector.talk(hotspot.dialogue_id.trim_prefix("@"))
			else:
				DialogueManager.start(hotspot.dialogue_id)
			machine.transition_to("IdleState")
		"danceoff":
			GameState.set_flag("danced")
			avatar.set_visual(Color(0.8, 0.35, 0.8), "dancing")
			var scene = load("res://scenes/ui/DanceOff.tscn")
			if scene:
				var game = scene.instantiate()
				game.finished.connect(_on_danceoff_finished)
				avatar.get_tree().current_scene.add_child(game)
			machine.transition_to("IdleState")
		_:
			# eat / dance / work — hold the pose briefly, then apply effects.
			# When you have real art, replace the timer with:
			#   var s := avatar.get_node("AnimatedSprite2D")
			#   s.play(hotspot.animation)
			#   await s.animation_finished
			avatar.set_visual(_color_for(hotspot.action), hotspot.action + "...")
			await avatar.get_tree().create_timer(1.0).timeout
			# Only finish if we're still the active state (player didn't click away).
			if machine.current == self:
				GameState.apply_effects(hotspot.effects)
				machine.transition_to("IdleState")


func _color_for(action: String) -> Color:
	match action:
		"eat": return Color(0.9, 0.5, 0.3)
		"dance": return Color(0.8, 0.35, 0.8)
		"work": return Color(0.45, 0.5, 0.9)
		_: return Color(0.6, 0.6, 0.6)


## Reward from the dance-off: Reputation (office morale) at a small Energy cost.
func _on_danceoff_finished(score: int) -> void:
	GameState.add_meter("reputation", score)
	GameState.add_meter("energy", -8)
