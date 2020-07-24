extends Node

const COLUMNS = 9
const ROWS = 16


var direction_array = init_directionArray(COLUMNS, ROWS)

 
func init_directionArray(columns, rows):
	var array = []
	for column in columns:
		array.append([])  
		for row in rows:
			array[column].append(Vector2())
	return array
