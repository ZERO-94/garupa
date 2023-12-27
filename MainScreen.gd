extends Node2D

var current_block;
var speed = 1.0;
var steps = 0;
var steps_req = 50;

var bands = {
	"roselia": ["roselia/Ako", "roselia/Sayo", "roselia/Rinko", "roselia/Lisa", "roselia/Yukina"]
}

func _ready():
	new_game();

func new_game():
	speed = 1.0;
	steps = 0;

func _physics_process(delta):
	if current_block == null:
		current_block = $Spawner.create_block($Playground);

	handle_input();
	
	if $Playground.is_current_block_landed(current_block):
		var tmp = current_block;
		current_block = null;
		# clear_blocks(tmp);
		return;

	steps += speed;
	if steps > steps_req:
		current_block.move_down();
		steps = 0;

func clear_blocks(current_block):
	var current_band = current_block.name.split("_")[0];
	var current_blocks = current_block.get_blocks();

	var matrix = $Playground.blocks_to_matrix();
	var count = traverse_matrix(matrix, current_blocks[0].x / GlobalConfig.BLOCK_SIZE - 1, current_blocks[0].y / GlobalConfig.BLOCK_SIZE - 1, current_band);
	if(count == bands[current_band].size() * 2):
		var tmp = [];
		for block in $Playground.get_children():
			if block.name.find(current_band) != -1:
				tmp.append(block);
		for block in tmp:
			var arr = block.name.split("_");
			$Spawner.stored_characters.append(arr[0] + "_" + arr[1]);
			$Spawner.spawned_characters.erase(arr[0] + "_" + arr[1]);
			block.queue_free();

func traverse_matrix(matrix, start_x, start_y, current_band):
	var x = start_x;
	var y = start_y;
	var count = 0;
	var current_block = matrix[x][y];
	if current_block == null:
		return 0;

	if current_block.name.replace("_", "/") in bands[current_band] and current_block.visited == false:
		count +=1;
		current_block.visited = true;
		if x + 1 < 6 and matrix[x + 1][y] != null:
			count += traverse_matrix(matrix, x + 1, y, current_band);
		if x - 1 >= 0 and matrix[x - 1][y] != null:
			count += traverse_matrix(matrix, x - 1, y, current_band);
		if y + 1 < 8 and matrix[x][y + 1] != null:
			count += traverse_matrix(matrix, x, y + 1, current_band);
		if y - 1 >= 0 and matrix[x][y - 1] != null:
			count += traverse_matrix(matrix, x, y - 1, current_band);

	return count;

func handle_input():
	var tmp = $Playground.calculate_boundaries(current_block);
	var nearest_left_positions = tmp["left"];
	var nearest_right_positions = tmp["right"];
	var nearest_top_positions = tmp["top"];
	var nearest_bottom_positions = tmp["bottom"];
	
	if Input.is_action_just_pressed("ui_right"):
		print(nearest_right_positions);
		current_block.move_right(nearest_right_positions.min());
	if Input.is_action_just_pressed("ui_left"):
		current_block.move_left(nearest_left_positions.max());
	if Input.is_action_just_pressed("ui_up"):
		current_block.rotate_block(nearest_left_positions.max(), \
		nearest_right_positions.min(), \
		nearest_bottom_positions.max(), \
		nearest_top_positions.min()
		);
