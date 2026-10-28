extends Sprite2D
## Noah is easy to overlook: he stays faded until you've *noticed* him, then he
## comes into focus. Also does the gentle idle bob like the other characters.

func _ready() -> void:
	var base_y := position.y
	var t := create_tween().set_loops()
	t.tween_property(self, "position:y", base_y - 5.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "position:y", base_y, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_update()
	GameState.flag_set.connect(func(_f): _update())


func _update() -> void:
	# Faded when unnoticed, full colour once you've seen him.
	self_modulate.a = 1.0 if GameState.has_flag("noticed_noah") else 0.3
