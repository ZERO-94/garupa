extends Node2D

const Playround = preload("res://Playground.gd");
const Spawner = preload("res://Spawner.gd");

var playground = null;
var spawner = null;
var score = 0;
var max_combo = 0;
var combo = 0;


func _ready():
	playground = $Playground;
	spawner = $Spawner;
	playground.new_game();

func _physics_process(delta):
	update_ui();
	playground.calculate_matrix();

	print_debug("is_in_combo: " + str(playground.is_in_combo));
	if(playground.is_in_combo):
		playground.recalculate_blocks_position();
		clear_blocks();
		return;

	if playground.current_block == null:
		var new_block = spawner.create_block();
		playground.set_current_block(new_block);

	if playground.is_current_block_landed():
		var tmp = playground.current_block;
		playground.current_block = null;
		playground.is_in_combo = true;
		return;

	handle_input();

	playground.steps += playground.speed;
	if playground.steps > playground.steps_req:
		playground.current_block.move_down();
		playground.steps = 0;

#TODO: enhance with combo later
func clear_blocks():
	var matrix: Array[Array] = [];
	for i in range(GlobalConfig.ROW):
		var cols = [];
		for j in range(GlobalConfig.COL):
			if playground.playground_in_matrix[i][j] != null:
				cols.append({
					"name": playground.playground_in_matrix[i][j].name,
					"band": playground.playground_in_matrix[i][j].band,
					"visited": false
				});
			else:
				cols.append(null);
		matrix.append(cols);

	var checked_bands = {};
	for i in range(GlobalConfig.ROW):
		for j in range(GlobalConfig.COL):
			if(matrix[i][j] != null and matrix[i][j].visited == false and checked_bands.find_key(matrix[i][j].band) == null):
				checked_bands[matrix[i][j].band] = traverse_matrix(matrix, i, j, matrix[i][j].band);
	var in_combo_this_check = false;
	for current_band in checked_bands:
		if(checked_bands[current_band] == 10): #There are 5 members in a band
			in_combo_this_check = true;
			combo += 1;
			score += 5 * 50; #will put the score inget_nodes_in_group character themselves
			var tmp = playground.get_tree().get_nodes_in_group("band:" + current_band);
			for block in tmp:
				spawner.available_characters.append(current_band + "/" + block.name);
				spawner.spawned_characters.erase(current_band  + "/" + block.name);
				block.queue_free();
	
	playground.is_in_combo = in_combo_this_check;
	
	if !in_combo_this_check:
		max_combo = max(max_combo, combo);
		combo = 0;

func update_ui():
	var score_label = get_node(NodePath("ScorePanel/CenterContainer/VSplitContainer/ScoreContainer/ScoreText"));
	score_label.text = str(score);
	var combo_label = get_node(NodePath("ScorePanel/CenterContainer/VSplitContainer/MaxComboContainer/MaxComboText"));
	combo_label.text = str(max_combo);

func traverse_matrix(matrix, start_x, start_y, current_band):
	var x = start_x;
	var y = start_y;
	var count = 0;
	var current_block = matrix[x][y];
	if  current_block ==null || current_block.visited == true || current_block.band != current_band:
		return count;

	current_block.visited = true;
	count +=1;
	if x + 1 < GlobalConfig.ROW and matrix[x + 1][y] != null:
		count += traverse_matrix(matrix, x + 1, y, current_band);
	if x - 1 >= 0 and matrix[x - 1][y] != null:
		count += traverse_matrix(matrix, x - 1, y, current_band);
	if y + 1 < GlobalConfig.COL and matrix[x][y + 1] != null:
		count += traverse_matrix(matrix, x, y + 1, current_band);
	if y - 1 >= 0 and matrix[x][y - 1] != null:
		count += traverse_matrix(matrix, x, y - 1, current_band);
	return count;

func handle_input():
	if Input.is_action_just_pressed("ui_right"):
		playground.current_block.move_right();
		if playground.is_collided_other_blocks(playground.current_block):
			playground.current_block.move_left();
	if Input.is_action_just_pressed("ui_left"):
		playground.current_block.move_left();
		if playground.is_collided_other_blocks(playground.current_block):
			playground.current_block.move_right();
	if Input.is_action_just_pressed("ui_up"):
		playground.current_block.rotate_char();
		if playground.is_collided_other_blocks(playground.current_block):
			playground.current_block.revert_rotate_char();
	if Input.is_action_just_pressed("ui_down"):
		playground.current_block.move_down();
