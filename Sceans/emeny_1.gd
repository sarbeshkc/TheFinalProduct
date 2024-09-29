extends CharacterBody2D

@export var gravity = 980
@export var speed = 50
var health = 100
var death_timer = 0.0
@export var death_duration = 0.4
@onready var slime_animation_player = $AnimationPlayer

func _physics_process(delta):

	
	# Add your enemy movement logic here
	
	move_and_slide()
	
	if health <= 0:
		death_timer += delta
		if death_timer >= death_duration:
			queue_free()  # Remove the enemy from the scene

func take_damage(amount: int):
	if health <= 0:
		return  # Enemy is already dead, don't process more damage
	
	health -= amount
	print("Enemy took ", amount, " damage! Remaining health: ", health)
	if health <= 0:
		die()

func die():
	print("Enemy defeated!")
	slime_animation_player.play("slime_die")

	# You might want to disable the HurtBox here as well
	# $MyHurtBox.set_deferred("monitorable", false)
