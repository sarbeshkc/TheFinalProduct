class_name warrior
extends Entity

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $CharacterStateMachine
@onready var sprite = $mirror/Sprite2D
@onready var audio_footsteps = $footstep
@onready var audio_sword = $sword
@onready var mirror: Node2D = $mirror
@onready var health_bar: ProgressBar = $CanvasLayer/HealthBar
@onready var audio_hurt: AudioStreamPlayer2D = $audio_hurt

@export var damage: float = 20
@export var warrior_max_health : int = 100

var isHurt : bool = false
var isDead : bool = false
var warrior_current_health : int

func _ready() -> void:
	super()
	warrior_current_health = warrior_max_health
	health_bar.init_health(warrior_max_health)
	state_machine.init(self)
	emit_signal("health_changed", warrior_current_health, warrior_max_health)
	
	#set_collision_layer(0)  # Set player to layer 1
	#set_collision_mask(1)   # Allow player to interact with layer 2 (enemy)
	
	#if not attack_raycast:
		#attack_raycast = RayCast2D.new()
		#add_child(attack_raycast)
	#attack_raycast.enabled = false
	#attack_raycast.collision_mask = 2  # Assuming enemy is on layer 2

func take_damage(amount: float) -> void:
	if isDead:
		return

	warrior_current_health = max(0, warrior_current_health - amount)
	health_bar.value = warrior_current_health
	emit_signal("health_changed", warrior_current_health, warrior_max_health)
	
	print("Player took damage. Current health: ", warrior_current_health)

	if warrior_current_health <= 0:
		die()
	else:
		isHurt = true
		animation_player.play("hurt")
		if Input.is_action_pressed("left_walk") or Input.is_action_pressed("right_walk"):
			pass
		if audio_hurt and not audio_hurt.playing:
			audio_hurt.play()

func get_attack_damage():
	return damage


func die():
	# Being safe, if die fuction is called by mistake
	if isDead:
		return
	
	isDead = true
	animation_player.play("death_warrior")
	# Removing collision shape and input
	set_physics_process(false)
	set_process_input(false)
	$CollisionShape2D.set_deferred("disabled", true)



func _unhandled_input(event: InputEvent) -> void:
	if not isDead:
		state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if not isDead:
		state_machine.process_physics(delta)

func _process(delta: float) -> void:
	if not isDead:
		state_machine.process_frame(delta)
		
func respawn() -> void:
	isDead = false
	warrior_current_health = warrior_max_health
	set_physics_process(true)
	set_process_input(true)
	$CollisionShape2D.set_deferred("disabled", false) 
	global_position= Vector2.ZERO
	animation_player.play("fall")
	emit_signal("health_changed", warrior_current_health, warrior_max_health)
	


func _on_hit_box_body_entered(body: Node2D) -> void:
	print("FUnction executed")
	if body is enemy:
		print("Enemy hit player")
		body.take_damage(damage)
