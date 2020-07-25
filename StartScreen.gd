extends Control




func _on_StartButton_pressed():
	get_tree().paused = false
	$CanvasLayer/BlackOverlay.visible = false
	$CanvasLayer/StartButton.visible = false
