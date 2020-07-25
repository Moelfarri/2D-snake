extends Node2D



func _ready():
	OS.low_processor_usage_mode = true
	get_tree().paused = true


