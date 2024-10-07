extends Node2D

@onready var audio_streamer = $guitar_sound
@onready var game_over_screen: CanvasLayer = $GameOverScreen

func _ready() -> void:
	audio_streamer.play()
	game_over_screen.hide()

func restart_game():
	print("restart_game() called in start script")
	game_over_screen.hide()
	respawn_warrior()
	respawn_enemies()
	print("Game fully restarted")

func respawn_enemies():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if is_instance_valid(enemy) and enemy.has_method("respawn"):
			enemy.respawn()
		else:
			print("Warning: An enemy instance is no longer valid or doesn't have a respawn method")


func respawn_warrior() -> void:
	for warrior in get_tree().get_nodes_in_group("warrior"):
		if is_instance_valid(warrior) and warrior.has_method("respawn"):
			warrior.respawn()
		else:
			print("Waring : The warrior couldn't be respawn")
			

	for warrior in get_tree().get_nodes_in_group("warrior"):
		if is_instance_valid(warrior) and warrior.has_method("respawn"):
			warrior.respawn()
		else:
			print("Warning: The warrior instance is no longer valid or doesn't have a respawn method")
		
func _process(delta):
	# Remove continuous checks to reduce console spam
	pass
