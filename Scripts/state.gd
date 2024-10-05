class_name State
extends  Node

@export var animation_name : String
@export var movement_speed : float = 200
@export var player_gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Getting a refrence to parent node
var parent : warrior

func enter() -> void:
	if animation_name:
		parent.animation_player.play(animation_name)

func exit() -> void:
	pass

func process_physics(delta :float) -> State:
	return null

func process_input(event : InputEvent) -> State:
	return null

func process_frame(delta : float) -> State:
	return null
