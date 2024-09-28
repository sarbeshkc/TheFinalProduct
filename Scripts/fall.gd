extends State

@export var idle_state : State
@export var run_state : State

func _ready() -> void:
	animation_name = "fall"

func enter():
	super()

func process_physics(delta : float) -> State:
	parent.velocity.y += player_gravity * delta
	
	var movement = Input.get_axis("left_walk", "right_walk")
	parent.velocity.x = movement * movement_speed
	
	if movement != 0:
		if movement > 0:
			parent.mirror.scale.x = 1
			#print("falling right")
		else:
			parent.mirror.scale.x = -1
			#print("falling left")
	
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if is_zero_approx(movement):
			return idle_state
		else:
			return run_state
	
	return null

func process_input(event : InputEvent) -> State:
	return null
