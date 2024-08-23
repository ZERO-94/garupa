extends Node2D 

const CharacterBlock = preload("res://src/characters/common/CharacterBlock.gd");
const BlockNode = preload("res://src/characters/common/BlockNode.gd");

var playground_in_matrix: Array[Array];
var current_block: CharacterBlock = null;
var speed = 1.0;
var steps = 0;
var steps_req = 50;
var is_in_combo = false;

func new_game():
	speed = 1.0;
	steps = 0;
	calculate_matrix();

func set_current_block(block: CharacterBlock):
	current_block = block;
	add_child(current_block);

func is_current_block_landed():
	var blocks = get_children();
	for block in blocks:
		if block.name != current_block.name:
			for b in block.get_block_nodes():
				if current_block.is_landed_on_node(b.global_position):
					return true;
		
	if current_block.is_landed_on_node(Vector2(current_block.position.x, GlobalConfig.BOTTM_BOUNDARY + GlobalConfig.BLOCK_SIZE / 2)):
		return true;
	
	return false;

func is_collided_other_blocks(block: CharacterBlock):
	var nodes = block.get_block_nodes();
	#check if collide
	for node in nodes:
		var node_matrix_position = node.get_matrix_position();
		if node_matrix_position.x < 0 or node_matrix_position.x > GlobalConfig.ROW - 1 or node_matrix_position.y < 0 or node_matrix_position.y > GlobalConfig.COL - 1:
			return true;
		for i in range(GlobalConfig.ROW):
			for j in range(GlobalConfig.COL):
				if playground_in_matrix[i][j] != null:
					if playground_in_matrix[i][j].name == block.name:
						continue;
					if node_matrix_position.x == i and node_matrix_position.y == j:
						return true;
	return false;

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

func recalculate_blocks_position():
	var calculated_chars = [];
	for j in range(7, -1, -1):
		for i in range(5, -1, -1):
			if playground_in_matrix[i][j] == null:
				continue;
			if(calculated_chars.find(playground_in_matrix[i][j].name) != -1):
				continue;
			calculated_chars.append(playground_in_matrix[i][j].name);
			var block = get_node(NodePath(playground_in_matrix[i][j].name)) as CharacterBlock;
			var bottom_blocks = block.get_bottom_nodes();
			var max_drop_gaps = [];
			for b in bottom_blocks:
				var node_matrix_position = b.get_matrix_position();
				var max_drop_gap = GlobalConfig.COL - 1 - node_matrix_position.y;
				for k in range(node_matrix_position.y + 1, GlobalConfig.COL):
					if playground_in_matrix[node_matrix_position.x][k] != null:
						max_drop_gap = (k - 1) - node_matrix_position.y;
						break;
				max_drop_gaps.append(max_drop_gap);
			
			var final_max_drop_gap = max_drop_gaps.min();
			
			if final_max_drop_gap > 0:
				block.global_position.y += final_max_drop_gap * GlobalConfig.BLOCK_SIZE;
				calculate_matrix();
	calculate_matrix();
