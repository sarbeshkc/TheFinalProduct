extends State

@export var idle_state : State
@export var run_state : State
@export var dash_speed : float = 1000
@export var dash_duration : float = 0.4
@export var fall_state : State

var dash_direction : float
var dash_timer : float = 0.0
var dash_tween : Tween

func _ready() -> void:
	animation_name = "dash_1"


func enter():
	print("dash state running")
	super()
	dash_direction = Input.get_axis("left_walk", "right_walk")
	parent.velocity.x = dash_speed * dash_direction
	dash_tween = create_tween()
	dash_tween.tween_property(parent, "velocity" ,Vector2.ZERO , 0.4)
	dash_tween.set_ease(Tween.EASE_IN)

func process_physics(delta : float) -> State:
	dash_timer += delta
	parent.velocity.y += player_gravity * delta
	
	#if dash_timer <= dash_duration:
		#if dash_direction > 0:
			#parent.velocity.x = 1 * dash_speed
		#else:
			#parent.velocity.x = -1 * dash_speed
			
	#dash_direction = Input.get_axis("left_walk", "right_walk")
	#dash_timer = 0.0
	#parent.velocity.x = dash_speed * dash_direction
	#dash_tween = create_tween()
	#dash_tween.tween_property(parent, "velocity" ,Vector2.ZERO , 0.4)
		
	parent.move_and_slide()
	
	#if dash_tween == null:
		#if Input.is_action_pressed("left_walk") or Input.is_action_pressed("right_walk"):
			#return run_state
		#else:
			#return idle_state
	#
	#else:
	if dash_timer >= dash_duration:
		var movement = Input.get_axis("left_walk", "right_walk")
		dash_timer = 0
		
		if parent.velocity.y > 0:
			return fall_state
		if is_zero_approx(movement):
			return idle_state
		else:
			return run_state
	
	return null

func process_input(event : InputEvent) -> State:
	return null
