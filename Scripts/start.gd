extends Node2D

@onready var audio_streamer = $guitar_sound
func _ready() -> void:
	audio_streamer.play()
	
