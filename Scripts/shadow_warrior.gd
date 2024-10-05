class_name warrior
extends Entity

@onready var animation_player = $AnimationPlayer
@onready var state_machine = $CharacterStateMachine
@onready var sprite = $mirror/Sprite2D
@onready var audio_footsteps = $footstep
@onready var audio_sword = $sword
@onready var mirror: Node2D = $mirror
@onready var health_label: Label = $HealthLabel
@onready var game_over_screen: CanvasLayer = $GameOverScreen
@onready var game_over_label: Label = $GameOverScreen/GameOverLabel

@export var damage: float = 20


var isHurt : bool = false
var isDead : bool = false


@export var warrior_max_health : int = 100
@onready var warrior_current_health : int = warrior_max_health
@onready var audio_hurt: AudioStreamPlayer2D = $audio_hurt

func _ready() -> void:
	super()
	max_health = warrior_max_health
	current_health = max_health
	state_machine.init(self)
	update_health_display()
	emit_signal("health_changed", current_health, max_health)
	game_over_screen.hide()  # Ensure the game over screen is hidden at start

func take_damage(amount: float) -> void:
	if isDead:
		return  # Don't take damage if already dead
	
	super(amount)
	isHurt = true
	animation_player.play("hurt")
	if audio_hurt and not audio_hurt.playing:
		audio_hurt.play()

	warrior_current_health = max(0, warrior_current_health - amount)
	update_health_display()
	emit_signal("health_changed", warrior_current_health, warrior_max_health)
	
	if warrior_current_health <= 0:
		die()

func get_attack_damage():
	return 10

func die():
	if isDead:
		return  # Prevent multiple death calls
	
	isDead = true
	
	# Play death animation

	animation_player.play("death_warrior")
	
	# Disable controls and collision
	set_physics_process(false)
	set_process_input(false)
	$CollisionShape2D.set_deferred("disabled", true)
	

	await animation_player.animation_finished
	# Trigger game over
	trigger_game_over()

func trigger_game_over():
	animation_player.play("death_warrior")
	game_over_label.text = "Game Over"
	game_over_screen.show()
	# You might want to add a retry button or return to main menu option here

func _unhandled_input(event: InputEvent) -> void:
	if not isDead:
		state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	if not isDead:
		state_machine.process_physics(delta)

func _process(delta: float) -> void:
	if not isDead:
		state_machine.process_frame(delta)

func update_health_display():
	if health_label:
		health_label.text = str(warrior_current_health) + "/" + str(warrior_max_health)
		# Optionally, change color based on health percentage
		var health_percentage = float(warrior_current_health) / warrior_max_health
		if health_percentage > 0.5:
			health_label.modulate = Color.GREEN
		elif health_percentage > 0.25:
			health_label.modulate = Color.YELLOW
		else:
			health_label.modulate = Color.RED
	
	print("Current Player Health is: ", warrior_current_health)

func _on_area_2d_body_entered(body):
	if body is enemy and not isDead:
		body.take_damage(damage)

func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is enemy and not isDead:
		body.take_damage(damage)

func heal(amount: float) -> void:
	if isDead:
		return  # Can't heal if dead
	
	warrior_current_health = min(warrior_current_health + amount, warrior_max_health)
	update_health_display()
	emit_signal("health_changed", warrior_current_health, warrior_max_health)

# New function to restart the game
func restart_game():
	# Reset warrior's state
	isDead = false
	warrior_current_health = warrior_max_health
	update_health_display()
	
	# Re-enable physics and input
	set_physics_process(true)
	set_process_input(true)
	$CollisionShape2D.set_deferred("disabled", false)
	
	# Hide game over screen
	game_over_screen.hide()
	
	# Reset position (adjust as needed)
	global_position = Vector2.ZERO
	
	# Play respawn animation if you have one
	animation_player.play("respawn")  # Create this animation if it doesn't exist
	
	emit_signal("health_changed", warrior_current_health, warrior_max_health)
