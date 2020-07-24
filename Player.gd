extends "pawn_Class.gd"


onready var Grid = get_parent()




func _process(_delta):
	var input_direction = get_input_direction()
	if not get_input_direction():
		return
		
	var target_position = Grid.request_move(self, input_direction)
	if target_position:
		move_to(target_position)




func get_input_direction():
	return Vector2(int(Input.is_action_just_pressed("ui_right")) - int(Input.is_action_just_pressed("ui_left")),
			int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up")))

 


func move_to(target_position):
	set_process(false)
	position = target_position
	set_process(true)
	


func _on_Timer_timeout():
	pass





