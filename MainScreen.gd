extends Node2D

var current_block: Node2D = null;
var speed = 1.0;
var steps = 0;
var steps_req = 50;
var is_in_combo = false;

func _ready():
	new_game();

func new_game():
	speed = 1.0;
	steps = 0;

func _physics_process(delta):
	if is_in_combo:
		recalculate_blocks_position();
		var blocks = $Playground.get_children();
		for block in blocks:
			clear_blocks(block);

	if current_block == null:
		current_block = $Spawner.create_block($Playground);

	handle_input();
	
	if $Playground.is_current_block_landed(current_block):
		var tmp = current_block;
		current_block = null;
		clear_blocks(tmp);
		return;

	steps += speed;
	if steps > steps_req:
		current_block.move_down();
		steps = 0;

func clear_blocks(current_block: Node2D):
	var current_band = current_block.get_meta("band");
	var current_blocks = current_block.get_blocks();

	var matrix = $Playground.blocks_to_matrix();
	var count = traverse_matrix(matrix, current_blocks[0].global_position.x / GlobalConfig.BLOCK_SIZE - 1, current_blocks[0].global_position.y / GlobalConfig.BLOCK_SIZE - 1, current_band);
	if(count == 10): #There are 5 members in a band
		is_in_combo = true;
		var tmp = [];
		for block in $Playground.get_children():
			if block.get_meta("band") == current_band:
				tmp.append(block);
		for block in tmp:
			$Spawner.available_characters.append(current_band + "/" + block.name);
			$Spawner.spawned_characters.erase(current_band  + "/" + block.name);
			block.queue_free();
	else:
		is_in_combo = false;

func traverse_matrix(matrix, start_x, start_y, current_band):
	var x = start_x;
	var y = start_y;
	var count = 0;
	var current_block = matrix[x][y];
	if  current_block ==null || current_block.visited == true:
		return count;

	current_block.visited = true;
	if current_block.band == current_band:
		count +=1;
		if x + 1 < 6 and matrix[x + 1][y] != null:
			count += traverse_matrix(matrix, x + 1, y, current_band);
		if x - 1 >= 0 and matrix[x - 1][y] != null:
			count += traverse_matrix(matrix, x - 1, y, current_band);
		if y + 1 < 8 and matrix[x][y + 1] != null:
			count += traverse_matrix(matrix, x, y + 1, current_band);
		if y - 1 >= 0 and matrix[x][y - 1] != null:
			count += traverse_matrix(matrix, x, y - 1, current_band);

	return count;

func recalculate_blocks_position():
	var calculated_chars = [];
	var matrix = $Playground.blocks_to_matrix();
	for i in range(5, -1, -1):
		for j in range(7, -1, -1):
			if matrix[i][j] == null:
				continue;
			if(calculated_chars.find(matrix[i][j].name) != -1):
				continue;
			var block = $Playground.get_node(NodePath(matrix[i][j].name));
			calculated_chars.append(matrix[i][j].name);
			var bottom_blocks = block.get_bottom_blocks();
			var max_drop_gaps = [];
			for b in bottom_blocks:
				
				var x = round((b.global_position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;
				var y = round((b.global_position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;
				var max_drop_gap = GlobalConfig.COL - 1 - y;
				for k in range(y + 1, GlobalConfig.COL):
					if matrix[x][k] != null:
						max_drop_gap = (k - 1) - y;
						break;
				max_drop_gaps.append(max_drop_gap);
			
			var final_max_drop_gap = max_drop_gaps.min();
			print(max_drop_gaps,"-", final_max_drop_gap);
			
			if final_max_drop_gap > 0:
				block.global_position.y += final_max_drop_gap * GlobalConfig.BLOCK_SIZE;

func handle_input():
	var tmp = $Playground.calculate_boundaries(current_block);
	var nearest_left_positions = tmp["left"];
	var nearest_right_positions = tmp["right"];
	var nearest_top_positions = tmp["top"];
	var nearest_bottom_positions = tmp["bottom"];
	
	if Input.is_action_just_pressed("ui_right"):
		current_block.move_right(nearest_right_positions.min());
	if Input.is_action_just_pressed("ui_left"):
		current_block.move_left(nearest_left_positions.max());
	if Input.is_action_just_pressed("ui_up"):
		current_block.rotate_char(nearest_left_positions.max(), \
		nearest_right_positions.min(), \
		nearest_bottom_positions.max(), \
		nearest_top_positions.min()
		);
	if Input.is_action_just_pressed("ui_down"):
		current_block.move_down();
