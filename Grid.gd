extends TileMap

#TODO: 
#MAKE MOVING BASED ON TICKING
#FIX A NICE UI AND MAKE IT MOBILE FRIENDLY
#CLEAN UP THE CODE, FOR EXAMPLE CHANGE PLAYER TO HEAD, etc

const BODY = preload("res://Body.tscn")
const FOOD = preload("res://Food.tscn")


enum CELL_TYPES {EMPTY = -1, PLAYER, OBSTACLE, FOOD, BODY}


var food_eaten = false
var previous_position_array = [Vector2()]
var body_part_id_counter = 1



func _ready():
	init_walls()
	for child in get_children():
		set_cellv(world_to_map(child.position), child.type)


func _process(_delta):
	if food_eaten:
		add_new_body_part()
		add_new_food()
		food_eaten = false
	


func get_cell_pawn(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)


func request_move(pawn, direction):
	var cell_start = world_to_map(pawn.position)
	var cell_target = cell_start + direction
	var cell_tile_id = get_cellv(cell_target)
	
	#SAVE PREVIOUS POSITIONS
	if pawn.type == CELL_TYPES.PLAYER:
		previous_position_array[0] = world_to_map(pawn.position)

	else: 
		previous_position_array[pawn.body_part_id] = world_to_map(pawn.position)
		
	#HOW THE GRID BEHAVES DEPENDING ON THE CELL THAT OUR PAWN IS MOVING TOWARDS	
	match cell_tile_id:
		CELL_TYPES.EMPTY:
			set_cellv(cell_target, pawn.type)
			set_cellv(cell_start, CELL_TYPES.EMPTY)
			if pawn.type == CELL_TYPES.PLAYER:
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
			if pawn.type == CELL_TYPES.PLAYER:
				Global.direction_array[cell_start.x][cell_start.y] = direction 
			pawn_name.queue_free()
			food_eaten = true
			return map_to_world(cell_target) + cell_size/2   #centers the vector otherwise we are top left corner


func add_new_body_part():
	var body = BODY.instance()
	body.body_part_id = body_part_id_counter
	body.set_name("Body" + str(body.body_part_id))
	body_part_id_counter += 1
	body.position = map_to_world(previous_position_array.back()) + cell_size/2 
	add_child(body)
	set_cellv(previous_position_array.back(), body.type)
	previous_position_array.append(Vector2())


func add_new_food():
	var random = RandomNumberGenerator.new()
	random.randomize()
	var random_position_x = random.randi_range(0,Global.COLUMNS-1)
	var random_position_y = random.randi_range(0,Global.ROWS-1)
	var random_position = Vector2(random_position_x, random_position_y)
	var cell_tile_id = get_cellv(random_position)
	
	while cell_tile_id != CELL_TYPES.EMPTY:
		random_position_x = random.randi_range(0,Global.COLUMNS-1)
		random_position_y = random.randi_range(0,Global.ROWS-1)
		random_position = Vector2(random_position_x, random_position_y)
		cell_tile_id = get_cellv(random_position)
	
	var food = FOOD.instance()
	food.position = map_to_world(random_position)
	add_child(food)
	set_cellv(random_position, food.type)
	

func init_walls():
	set_cell(-1, -1, CELL_TYPES.OBSTACLE)
	for i in Global.COLUMNS+1:
		set_cell(i, -1, CELL_TYPES.OBSTACLE)
		set_cell(i, Global.ROWS, CELL_TYPES.OBSTACLE)
	for j in Global.ROWS+1:
		set_cell(-1, j, CELL_TYPES.OBSTACLE)
		set_cell(Global.COLUMNS, j, CELL_TYPES.OBSTACLE)


