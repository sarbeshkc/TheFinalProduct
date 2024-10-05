extends CanvasLayer

@onready var game_over_label: Label = $GameOverLabel
@onready var restart_button: Button = $RestartButton

func _ready():
	hide()
	restart_button.pressed.connect(_on_restart_button_pressed)

func show_game_over():
	game_over_label.text = "Game Over"
	show()

func _on_restart_button_pressed():
	hide()
	var start_node = get_parent()
	if start_node and start_node.has_method("restart_game"):
		start_node.restart_game()
	else:
		print("Error: Could not find start node or restart_game method")
