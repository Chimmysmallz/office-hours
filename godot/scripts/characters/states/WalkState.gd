extends State
## Walk toward a target point. On arrival, either perform a queued action
## (from a hotspot) or drop back to idle.

const SPEED := 160.0
var _target: Vector2
var _hotspot = null


func enter(msg := {}) -> void:
	_target = msg.get("target", avatar.global_position)
	_hotspot = msg.get("hotspot", null)
	avatar.set_visual(Color(0.4, 0.8, 0.45), "walking")


func physics_update(_delta: float) -> void:
	var to_target: Vector2 = _target - avatar.global_position
	if to_target.length() < 6.0:
		if _hotspot != null:
			machine.transition_to("ActionState", {"hotspot": _hotspot})
		else:
			machine.transition_to("IdleState")
		return
	avatar.velocity = to_target.normalized() * SPEED
	avatar.move_and_slide()
