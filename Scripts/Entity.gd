# Entity.gd
class_name Entity
extends CharacterBody2D

signal health_changed(new_health : float)

@export var max_health : float = 100
var current_health : float

@onready var hurt_box : Area2D = $HitBox
func _ready() -> void:
	current_health = max_health
	#hurt_box.area_entered(_on_hurt_box_area_entered)
	
func take_damage(amount : float):
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	(current_health)
	if current_health <= 0:
		die()
		
func die():#override in subclasses
	queue_free()
func display(health : float) -> void:
	print(health)
		
func heal(amount: float):
	current_health = max(max_health , current_health + amount)
	health_changed.emit(current_health, max_health)
	
func get_attack_damage() -> float:  #Override in subclasses
	return 0.0
	
		
		
