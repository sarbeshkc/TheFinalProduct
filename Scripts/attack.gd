extends State

@export var idle_state : State
@export var run_state : State

@export var attack_speed : float = 400
@export var attack_duration : float = 0.7

var attack_direction : float
var attack_timer : float = 0.0
var attack_tween : Tween

func _ready() -> void:
	animation_name = "attack_final"

func enter():
	parent.audio_sword.play()
	super()
	attack_direction = Input.get_axis("left_walk", "right_walk")
	parent.velocity.x = attack_speed * attack_direction
	attack_tween = create_tween()
	attack_tween.tween_property(parent, "velocity" ,Vector2.ZERO , 0.4)
	attack_tween.set_ease(Tween.EASE_IN)


func process_physics(delta : float) -> State:
	
	attack_timer += delta
	parent.velocity.y += player_gravity * delta
	
	var movement = Input.get_axis("left_walk" , "right_walk")
		
	
	
	if attack_timer >= attack_duration:
		attack_timer = 0
		
		if is_zero_approx(movement):
			parent.audio_sword.stop()
			return idle_state
		else:
			parent.audio_sword.stop()
			return run_state
	
	return null

func process_input(event : InputEvent) -> State:
	return null
