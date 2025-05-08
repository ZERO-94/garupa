extends Node2D 

const CharacterBlock = preload("res://src/characters/common/CharacterBlock.gd");
const BlockNode = preload("res://src/characters/common/BlockNode.gd");
const DEFAULT_SPEED = 1.0;

var playground_in_matrix: Array[Array];
var current_block: CharacterBlock = null;
var speed = DEFAULT_SPEED;
var steps = 0;
var steps_req = 50;
var is_in_combo = false;
var score = 0;
var max_combo = 0;
var combo = 0;

var spawned_chars: Array[String] = [];

func new_game():
	speed = DEFAULT_SPEED;
	steps = 0;
	is_in_combo = false;
	current_block = null;

func _physics_process(delta):
	calculate_matrix();
	if is_in_combo:	
		var is_changed = recalculate_blocks_position();
		if is_changed:
			calculate_matrix();
		clear_blocks();

	#No element to interact so do nothing until got new block from spawner
	if !is_in_combo and current_block == null:
		return;

	if current_block:
		handle_input();
		steps += speed;
		if steps > steps_req:
			var matrix_before_move = playground_in_matrix;
			var is_out_of_bottom = false;
			for node in current_block.get_block_nodes():
				if node.get_matrix_position().y + 1 == GlobalConfig.COL:
					is_out_of_bottom = true;
					break;
			var collided = null;
			#replace with physic boundary later
			if !is_out_of_bottom:
				collided = current_block.move_down();
			if is_out_of_bottom or collided:
				current_block = null;
				is_in_combo = true;
			calculate_matrix();
			steps = 0;

func set_current_block(block: CharacterBlock):
	current_block = block;
	steps = 0;
	speed = DEFAULT_SPEED;
	spawned_chars.append(block.get_band() + "/" + block.name);
	add_child(current_block);

func calculate_matrix() -> Array[Array]:
	var blocks_pg = get_children() as Array[CharacterBlock];
	var map: Array[Array] = [];
	for i in range(GlobalConfig.ROW):
		var cols = [];
		cols.resize(GlobalConfig.COL);
		cols.fill(null);
		map.append(cols);

	for block in blocks_pg:
		var nodes = block.get_block_nodes();
		for node in nodes:
			var node_matrix_position = node.get_matrix_position();
			map[node_matrix_position.x][node_matrix_position.y] = {"name": block.name, "band": block.get_band()};
	playground_in_matrix = map;
	return map;

func recalculate_blocks_position() -> bool:
	var calculated_chars = [];
	var is_changed = false;
	for j in range(GlobalConfig.COL - 1, -1, -1):
		for i in range(GlobalConfig.ROW - 1, -1, -1):
			if playground_in_matrix[i][j] == null or calculated_chars.find(playground_in_matrix[i][j].name) != -1:
				continue;
			calculated_chars.append(playground_in_matrix[i][j].name);
			var block = get_node(NodePath(playground_in_matrix[i][j].name)) as CharacterBlock;
			var nodes = block.get_block_nodes();
			var max_drop_gaps = [];
			for b in nodes:
				var node_matrix_position = b.get_matrix_position();
				var max_drop_gap = GlobalConfig.COL - 1 - node_matrix_position.y;
				for k in range(node_matrix_position.y + 1, GlobalConfig.COL):
					if playground_in_matrix[node_matrix_position.x][k] != null and playground_in_matrix[node_matrix_position.x][k].name != block.name:
						max_drop_gap = (k - 1) - node_matrix_position.y;
						break;
				max_drop_gaps.append(max_drop_gap);
			var final_max_drop_gap = max_drop_gaps.min();
			
			if final_max_drop_gap > 0:
				#since the movement is by frame so need to update this manually for recalculate
				for b in nodes:
					var node_matrix_position = b.get_matrix_position();
					playground_in_matrix[node_matrix_position.x][node_matrix_position.y] = null;
					playground_in_matrix[node_matrix_position.x][node_matrix_position.y + final_max_drop_gap] = {"name": block.name, "band": block.get_band()};
				block.global_position.y += final_max_drop_gap * GlobalConfig.BLOCK_SIZE;
				is_changed = true;
	return is_changed;

func handle_input():
	if Input.is_action_just_pressed("ui_right"):
		current_block.move_right();
	if Input.is_action_just_pressed("ui_left"):
		current_block.move_left();
	if Input.is_action_just_pressed("ui_up"):
		current_block.rotate_char();
	if Input.is_action_pressed("ui_down"):
		speed = 15.0;
	if Input.is_action_just_released("ui_down"):
		speed = DEFAULT_SPEED;

func clear_blocks():
	var matrix = CommonUtils.set_matrix_for_visting(playground_in_matrix);
	var checked_bands = {};
	var cleared_blocks = [];
	for i in range(GlobalConfig.ROW):
		for j in range(GlobalConfig.COL):
			if(matrix[i][j] != null and matrix[i][j].visited == false and checked_bands.find_key(matrix[i][j].band) == null):
				checked_bands[matrix[i][j].band] = CommonUtils.traverse_matrix(matrix, i, j, matrix[i][j].band);
	var number_of_cleared_bands = 0;
	for current_band in checked_bands:
		if(checked_bands[current_band] == 10): #There are 5 members in a band
			number_of_cleared_bands += 1;
			var tmp = get_tree().get_nodes_in_group("band:" + current_band);
			for block in tmp:
				cleared_blocks.append(block);
				var current_block_file_name = current_band + "/" + block.name;
				spawned_chars.erase(current_block_file_name);
				block.queue_free();
	self.is_in_combo = cleared_blocks.size() > 0;
	if cleared_blocks.size() > 0:
		max_combo = max(max_combo, combo);
		combo += number_of_cleared_bands;
		score += number_of_cleared_bands * 500 + (number_of_cleared_bands - 1) * 100;
	else:
		combo = 0;
	#append the block to the spawner
	var spawner = get_node("../Spawner") as Spawner;
	for block in cleared_blocks:
		spawner.append_characters([block.get_band() + "/" + block.name]);
