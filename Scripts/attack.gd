extends State

@export var idle_state : State
@export var run_state : State

@export var attack_speed : float = 400
@export var attack_duration : float = 1.5

var attack_direction : float
var attack_timer : float = 0.0
var attack_tween : Tween

func _ready() -> void:
	animation_name = "attack_1"

func enter():
	super()
	attack_direction = Input.get_axis("left_walk", "right_walk")
	parent.velocity.x = attack_speed * attack_direction
	attack_tween = create_tween()
	attack_tween.tween_property(parent, "velocity" ,Vector2.ZERO , 0.4)
	attack_tween.set_ease(Tween.EASE_IN)


func process_physics(delta : float) -> State:
	
	attack_timer += delta
	
	
	if attack_timer >= attack_duration:
		var movement = Input.get_axis("left_walk", "right_walk")
		attack_timer = 0
		
		if is_zero_approx(movement):
			return idle_state
		else:
			return run_state
	
	return null

func process_input(event : InputEvent) -> State:
	return null
