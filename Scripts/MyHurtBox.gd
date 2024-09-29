class_name MyHurtBox
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hitbox: Area2D) -> void:
	print("Area entered: ", hitbox)
	
	if not hitbox is MyHitBox:
		print("Not a MyHitBox")
		return
	
	if not owner.has_method("take_damage"):
		print("Owner doesn't have take_damage method")
		return
	
	print("Applying damage: ", hitbox.damage)
	owner.take_damage(hitbox.damage)
