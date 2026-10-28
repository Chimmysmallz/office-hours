extends Sprite2D
## A gentle, looping idle "breathing" bob so characters feel alive instead of
## frozen. Attach to any character Sprite2D. Bobs a few pixels up and down forever.

func _ready() -> void:
	var base_y := position.y
	var t := create_tween().set_loops()
	t.tween_property(self, "position:y", base_y - 5.0, 1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "position:y", base_y, 1.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
