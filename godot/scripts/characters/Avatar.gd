extends CharacterBody2D
## The player avatar. Reused in every room. Its "brain" is the StateMachine child.

@onready var machine: StateMachine = $StateMachine


func _ready() -> void:
	add_to_group("avatar")


## Called by a Hotspot when clicked: walk to a point, then perform its action.
func walk_to_and_do(point: Vector2, hotspot) -> void:
	machine.transition_to("WalkState", {"target": point, "hotspot": hotspot})


## Updates the little status label above the avatar ("walking", "eat...", "").
## The `color` argument is kept so the states don't need to change; now that the
## avatar is a real Sprite2D we no longer tint a placeholder square. To animate
## later, add an AnimatedSprite2D and call .play(hotspot.animation) in ActionState.
func set_visual(_color: Color, action_text: String = "") -> void:
	var label := get_node_or_null("Label")
	if label:
		label.text = action_text
