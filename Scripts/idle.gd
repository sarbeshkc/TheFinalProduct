extends State

@export var run_state : State
@export var dash_state :State
@export var attack_state : State
@export var jump_state : State

func _ready() -> void:
	animation_name = "idle"
	
func enter() -> void:
	super()
	parent.velocity.x = 0
	
func process_physics(delta : float) -> State:
	
	parent.velocity.y += player_gravity * delta
	
	parent.move_and_slide()
	return null

	

func process_input(event : InputEvent) -> State:
	if Input.is_action_just_pressed("left_walk") or Input.is_action_just_pressed("right_walk"):
		return run_state
		
	if Input.is_action_just_pressed("shift_dash") or Input.is_action_just_pressed("mouse_dash"):
		var movement = Input.get_axis("left_walk", "right_walk")
		if movement != 0:
			return dash_state

	if event.is_action_pressed("jump") and parent.is_on_floor():
		return jump_state
	
	if event.is_action_pressed("attack"):
		return attack_state
	return null
	
