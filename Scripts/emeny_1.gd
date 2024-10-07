class_name enemy
extends Entity

@export var move_speed: float = 50
@export var damage: float = 10.0
@export var slime_max_health: float = 100
@export var knockback: float = 400

var direction: Vector2 = Vector2.LEFT
var gravity: float = 980.0
var slime_current_health: float

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $HitBox
@onready var health_bar: ProgressBar = $HealthBar

func _ready():
	#add_to_group("enemies")
	#set_collision_layer_value(2, true)  # Set enemy to layer 2
	#set_collision_mask_value(1, true)   # Allow enemy to interact with layer 1 (player)
	
	slime_current_health = slime_max_health
	health_bar.init_health(slime_current_health)	
	emit_signal("health_changed", slime_current_health, slime_max_health)
	
func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	velocity.x = direction.x * move_speed
	move_and_slide()
	
	if is_on_wall():
		direction.x *= -1
		sprite.flip_h = not sprite.flip_h
	
	if is_on_floor() and animation_player.current_animation != "slime_hurt" and animation_player.current_animation != "slime_die":
		animation_player.play("slime_walk")

func take_damage(amount: float):
	print("Enemy take_damage called with amount: ", amount)  # Debug print
	slime_current_health = max(0, slime_current_health -amount)
	health_bar.value = slime_current_health
	print("Enemy took damage. Current health: ", slime_current_health)
	emit_signal("health_changed", slime_current_health, slime_max_health)
	
	
	if slime_current_health <= 0:
		die()
	else:
		if animation_player:
			animation_player.play("slime_hurt")
			await animation_player.animation_finished
			if slime_current_health > 0:
				animation_player.play("slime_walk")
		else:
			print("Error: AnimationPlayer node not found!")

func die() -> void:
	print("Enemy died. Final health: ", slime_current_health)
	if animation_player:
		animation_player.play("slime_die")
		await animation_player.animation_finished
	queue_free()

#func _on_area_2d_body_entered(body):
	#if body is warrior:
		#print("Enemy hit player")
		#body.take_damage(damage)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is warrior:
		print("Enemy hit player")
		body.take_damage(damage)
