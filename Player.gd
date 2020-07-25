extends "pawn_Class.gd"


onready var Grid = get_parent()
var input_direction = Vector2.DOWN



func _process(_delta):
	#IF SELF CONTROL, move input_direction variable into process and and have if not get_input_direction() instead of Global.wait_time if sentence
	if get_input_direction():
		input_direction = get_input_direction()
	
	if not Global.wait_time == 0:  
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





