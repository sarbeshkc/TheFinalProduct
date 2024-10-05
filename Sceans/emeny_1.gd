class_name enemy
extends Entity

@export var move_speed: float = 50
@export var damage: float = 10.0
var direction: Vector2 = Vector2.LEFT  # Start moving left
var gravity: float = 980.0
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $HitBox
@export var slime_max_health : int = 100
@onready var slime_current_health : int = slime_max_health
@onready var slime_health_label : Label = $Label

func _ready():
	max_health = slime_max_health
	current_health = max_health
	update_health_display()
	emit_signal("health_changed", current_health, max_health)
	area_2d.body_entered.connect(_on_area_2d_body_entered)
	# Initially hide the label
	slime_health_label.hide()

func _physics_process(delta):
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Apply horizontal movement
	velocity.x = direction.x * move_speed
	
	move_and_slide()
	
	# Change direction when hitting a wall
	if is_on_wall():
		direction.x *= -1
		sprite.flip_h = not sprite.flip_h
	
	# Update animation
	if is_on_floor() and animation_player.current_animation != "slime_hurt" and animation_player.current_animation != "slime_die":
		animation_player.play("slime_walk")

func take_damage(amount: float):
	current_health -= amount
	print("Enemy health : ", current_health)
	update_health_display()
	slime_health_label.show()
	
	if current_health <= 0:
		die()
	else:
		animation_player.play("slime_hurt")
		await animation_player.animation_finished
		if current_health > 0:  # Check again in case more damage was taken
			animation_player.play("slime_walk")
		
	# Hide the label after a short delay
	await get_tree().create_timer(2.0).timeout
	slime_health_label.hide()

func die() -> void:
	animation_player.play("slime_die")
	await animation_player.animation_finished
	queue_free()

func _on_area_2d_body_entered(body):
	if body is warrior:  # Make sure 'warrior' is the class_name of your shadow_warrior
		body.take_damage(damage)

func get_health():
	return current_health

func update_health_display():
	slime_health_label.text = str(current_health) + "/" + str(max_health)
	# Optionally, you can change the color based on health percentage
	var health_percentage = float(current_health) / max_health
	if health_percentage > 0.5:
		slime_health_label.modulate = Color.GREEN
	elif health_percentage > 0.25:
		slime_health_label.modulate = Color.YELLOW
	else:
		slime_health_label.modulate = Color.RED
