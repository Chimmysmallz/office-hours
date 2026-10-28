extends Node
class_name State
## Base class for every avatar state. Override the hooks you need.

var machine: StateMachine
var avatar: CharacterBody2D


func enter(_msg := {}) -> void:
	pass


func exit() -> void:
	pass


func physics_update(_delta: float) -> void:
	pass
