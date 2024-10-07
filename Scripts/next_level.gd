extends Area2D

const FILE_BEGIN = "res://levels/level_"




func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("warrior"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_scene_file = current_scene_file.to_int() + 1
		
		var next_level_path = FILE_BEGIN + str(next_scene_file) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
