extends TileMap

const BODY = preload("res://Body.tscn")

enum CELL_TYPES {EMPTY = -1, PLAYER, OBSTACLE, FOOD, BODY}

var food_eaten = false
var player_previous_position


func _ready():
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)

func _process(_delta):
	if food_eaten:
		spawn_body_part()
		food_eaten = false
	


func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_tile_id = get_cellv(cell_target)
	

		
	match cell_tile_id:
		CELL_TYPES.EMPTY:
			set_cellv(cell_target, pawn.type)
			set_cellv(cell_start, CELL_TYPES.EMPTY)
			Global.direction_array[cell_start.x][cell_start.y] = direction
			return map_to_world(cell_target) + cell_size/2   #centers the vector otherwise we are top left corner
		CELL_TYPES.OBSTACLE:
			#var pawn_name = get_cell_pawn(cell_target, cell_tile_id).name
			print("collided")
			
		CELL_TYPES.BODY:
			print("colliding with body")
			
		CELL_TYPES.PLAYER:
			print("colliding with player")
		CELL_TYPES.FOOD:
			var pawn_name = get_cell_pawn(cell_target)
			set_cellv(cell_target, CELL_TYPES.PLAYER)
			set_cellv(cell_start, CELL_TYPES.EMPTY)
			Global.direction_array[cell_start.x][cell_start.y] = direction 
			pawn_name.queue_free()
			food_eaten = true
			
			#TODO: FIX THIS PLAYER PREV POS THING
			player_previous_position = world_to_map(pawn.position)
			
			return map_to_world(cell_target) + cell_size/2   #centers the vector otherwise we are top left corner


func spawn_body_part():
	var body = BODY.instance()
	body.position = map_to_world(player_previous_position) + cell_size/2 
	add_child(body)
	set_cellv(player_previous_position, body.type)
