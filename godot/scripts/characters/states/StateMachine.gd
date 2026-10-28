extends Node
class_name StateMachine
## Runs one active State at a time and handles transitions between them.
## Add a new ability = drop in a new State node. No giant if/else anywhere.

@export var initial_state: NodePath
var current: State


func _ready() -> void:
	var owner_avatar: CharacterBody2D = get_parent()
	for child in get_children():
		if child is State:
			child.machine = self
			child.avatar = owner_avatar
	current = get_node(initial_state)
	current.enter()


func _physics_process(delta: float) -> void:
	if current:
		current.physics_update(delta)


func transition_to(state_name: String, msg := {}) -> void:
	if not has_node(state_name):
		return
	if current:
		current.exit()
	current = get_node(state_name)
	current.enter(msg)
