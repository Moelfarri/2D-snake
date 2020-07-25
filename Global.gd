extends Node

const COLUMNS = 9
const ROWS = 16


var direction_array = init_directionArray(COLUMNS, ROWS)
var wait_time = 0

func _process(_delta):
	wait_time += 1
	if wait_time == 10:
		wait_time = 0



func init_directionArray(columns, rows):
	var array = []
	for column in columns:
		array.append([])  
		for row in rows:
			array[column].append(Vector2())
	return array


