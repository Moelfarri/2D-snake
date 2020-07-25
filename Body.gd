extends "pawn_Class.gd"


onready var Grid = get_parent()
var body_part_id 




func _process(_delta):
	#for self control replace global.wait_time with Grid.get_node("Player").get_input_direction()
	if not Global.wait_time == 0:
		return
	
	var position_in_grid = Grid.world_to_map(Grid.get_node("Body" + str(body_part_id)).position) 
	var target_position = Grid.request_move(self, Global.direction_array[position_in_grid.x][position_in_grid.y])
	
	if target_position:
		move_to(target_position)


func move_to(target_position):
	set_process(false)
	position = target_position
	set_process(true)
	


