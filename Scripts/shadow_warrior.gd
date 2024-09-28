extends CharacterBody2D
class_name warrior

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $CharacterStateMachine
@onready var sprite = $mirror/Sprite2D
@onready var audio_footsteps = $footstep
@onready var mirror: Node2D = $mirror

func _ready() -> void:
	state_machine.init(self)
	
func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
