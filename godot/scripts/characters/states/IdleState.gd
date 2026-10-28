extends State
## Standing still, waiting for the player to click something.

func enter(_msg := {}) -> void:
	avatar.velocity = Vector2.ZERO
	avatar.set_visual(Color(0.3, 0.6, 0.9), "")
