extends State

@export var fall_state : State
@export var idle_state : State
@export var run_state : State
@export var attack_state : State
@export var dash_state : State

@export var jump_velocity : float = -200

func _ready() -> void:
	animation_name = "jump"

func enter():
	super()
	parent.velocity.y = jump_velocity

func process_physics(delta : float) -> State:
	parent.velocity.y += player_gravity * delta
	
	var movement = Input.get_axis("left_walk", "right_walk")
	parent.velocity.x = movement * movement_speed
	
	if movement != 0:
		if movement > 0:
			parent.mirror.scale.x = 1
		
		else:
			parent.mirror.scale.x = -1
		
	
	parent.move_and_slide()
	
	if parent.velocity.y > 0:
		return fall_state
	
	return null

func process_input(event : InputEvent) -> State:
	if Input.is_action_just_pressed("attack"):
		return attack_state
		
	if Input.is_action_just_pressed("shift_dash") or Input.is_action_just_pressed("mouse_dash"):
		var movement = Input.get_axis("left_walk", "right_walk")
		if movement != 0:
			return dash_state
	return null
