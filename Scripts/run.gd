extends State

@export var idle_state : State
@export var dash_state : State
@export var jump_state : State
@export var attack_state : State

func _ready() -> void:
	animation_name = "run"
	
func enter():
	super()
	parent.audio_footsteps.play()
	
func process_physics(delta : float) -> State:
	var movement = Input.get_axis("left_walk" , "right_walk")
	
	parent.velocity.y += player_gravity * delta
	parent.velocity.x = movement * movement_speed
	
	if movement != 0:
		
		if movement > 0:
			parent.mirror.scale.x = 1
			#print("running right")
			
		else:
			parent.mirror.scale.x = -1
			#print("running left")
			
		
		#parent.sprite.flip_h = !(movement > 0)
		
		
	parent.move_and_slide()
	
	return null
		
func process_input(event : InputEvent) -> State:
	#if parent.velocity.x == 0:
		#return idle_state
	if event.is_action_released("left_walk") or event.is_action_released("right_walk"):
		if Input.get_axis("left_walk", "right_walk") == 0:
			parent.audio_footsteps.stop()
			return idle_state
			
	if Input.is_action_just_pressed("shift_dash") or Input.is_action_just_pressed("mouse_dash"):
		var movement = Input.get_axis("left_walk", "right_walk")
		if movement != 0:
			parent.audio_footsteps.stop()
			return dash_state
			
			
	if event.is_action_pressed("jump") and parent.is_on_floor():
		parent.audio_footsteps.stop()
		return jump_state
	
	if event.is_action_pressed("attack"):
		parent.audio_footsteps.stop()
		return attack_state
	
	return null
	
