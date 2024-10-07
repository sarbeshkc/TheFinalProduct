# character_state_machine.gd
extends Node

@export var starting_state : State
var current_state : State
@onready var player = Node

func init(parent : warrior) -> void:
	for child in get_children():
		child.parent = parent
	
	change_state(starting_state)
	
func change_state(new_state : State) -> void:
	if current_state:
		current_state.exit()
		
	current_state = new_state
	current_state.enter()
	
func process_physics(delta : float) -> void:
	var new_state = current_state.process_physics(delta)
	
	if player is CharacterBody2D:
		var body := player as CharacterBody2D
		for i in body.get_slide_collision_count():
			var collision = body.get_slide_collision(i)
			var collider = collision.get_collider()
			if collider.is_in_group("enemies"):
				if player.has_method("take_damage"):
					player.call("take_damage", 2.0)  # 2% damage on touch
	
	if new_state:
		change_state(new_state)

func process_input(event : InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)
		
func process_frame(delta : float) ->void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
