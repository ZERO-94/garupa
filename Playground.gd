extends Node2D 

func is_current_block_landed(current_block):
	var blocks = get_children();
	for block in blocks:
		if block.name != current_block.name:
			for b in block.get_blocks():
				if current_block.is_landed_on_block(b.global_position):
					return true;

	if current_block.is_landed(GlobalConfig.BOTTM_BOUNDARY):
		return true;
	
	return false;

func calculate_boundaries(current_block):
	var nearest_left_positions = [GlobalConfig.LEFT_BOUNDARY];
	var nearest_right_positions = [GlobalConfig.RIGHT_BOUNDARY];
	var nearest_top_positions = [GlobalConfig.TOP_BOUNDARY];
	var nearest_bottom_positions = [GlobalConfig.BOTTM_BOUNDARY];
	var current_blocks = current_block.get_blocks();
	for block in current_blocks:
		var nearest_left_position = nearest_left_block(block.global_position);
		var nearest_right_position = nearest_right_block(block.global_position);
		var nearest_top_position = nearest_top_block(block.global_position);
		var nearest_bottom_position = nearest_bottom_block(block.global_position);

		for b in current_blocks:
			if nearest_left_position != null and nearest_left_position.x == b.global_position.x:
				nearest_left_position = null;
			if nearest_right_position != null and nearest_right_position.x == b.global_position.x:
				nearest_right_position = null;
			if nearest_top_position != null and nearest_top_position.y == b.global_position.y:
				nearest_top_position = null;
			if nearest_bottom_position != null and nearest_bottom_position.y == b.global_position.y:
				nearest_bottom_position = null;

		if nearest_left_position != null:
			nearest_left_positions.append(nearest_left_position.x + GlobalConfig.BLOCK_SIZE / 2);
		if nearest_right_position != null:
			nearest_right_positions.append(nearest_right_position.x - GlobalConfig.BLOCK_SIZE / 2);
		if nearest_top_position != null:
			nearest_top_positions.append(nearest_top_position.y - GlobalConfig.BLOCK_SIZE / 2);
		if nearest_bottom_position != null:
			nearest_bottom_positions.append(nearest_bottom_position.y + GlobalConfig.BLOCK_SIZE / 2);

	return {
		"left": nearest_left_positions,
		"right": nearest_right_positions,
		"top": nearest_top_positions,
		"bottom": nearest_bottom_positions
	};
	

func blocks_to_matrix():
	var blocks_pg = get_children();
	var map = [];
	for i in range(6):
		var tmp = [];
		tmp.resize(8);
		tmp.fill(null);
		map.append(tmp);

	for block in blocks_pg:
		var blocks = block.get_blocks();
		for tmp in blocks:
			# var arr = block.name.split("_");
			var x = round((tmp.global_position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE));
			var y = round((tmp.global_position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE));
			map[x - 1][y - 1] = {"name": block.name, "band": block.get_meta("band"), "visited": false};

	return map;

func nearest_right_block(position: Vector2): # return null if no block on the right
	#convert position to matrix
	var x = round((position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;
	var y = round((position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;

	if(x > GlobalConfig.ROW - 1 || x < 0 || y > GlobalConfig.COL - 1 || y < 0):
		return null;

	var matrix = blocks_to_matrix();
	var nearest = null;
	for i in range(x + 1, GlobalConfig.ROW):
		if matrix[i][y] != null:
			nearest = i;
			break;
	
	if nearest == null:
		return null;

	#convert back to Vector2
	var nearest_x = (nearest + 1) * GlobalConfig.BLOCK_SIZE + GlobalConfig.LEFT_BOUNDARY - GlobalConfig.BLOCK_SIZE / 2;

	return Vector2(nearest_x, position.y);

func nearest_left_block(position: Vector2): # return null if no block on the left
	#convert position to matrix
	var x = round((position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;
	var y = round((position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;

	if(x > GlobalConfig.ROW - 1 || x < 0 || y > GlobalConfig.COL - 1 || y < 0):
		return null;

	var matrix = blocks_to_matrix();
	var nearest = null;
	for i in range(x - 1, -1, -1):
		if matrix[i][y] != null:
			nearest = i;
			break;
	if nearest == null:
		return null;
	#convert back to Vector2
	var nearest_x = (nearest + 1) * GlobalConfig.BLOCK_SIZE + GlobalConfig.LEFT_BOUNDARY - GlobalConfig.BLOCK_SIZE / 2;

	return Vector2(nearest_x, position.y);

func nearest_top_block(position: Vector2): # return null if no block on the top
	#convert position to matrix
	var x = round((position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;
	var y = round((position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;

	if(x > GlobalConfig.ROW - 1 || x < 0 || y > GlobalConfig.COL - 1 || y < 0):
		return null;

	var matrix = blocks_to_matrix();
	var nearest = null;
	for i in range(y - 1, -1, -1):
		if matrix[x][i] != null:
			nearest = i;
			break;
	if nearest == null:
		return null;
	#convert back to Vector2
	var nearest_y = (nearest + 1) * GlobalConfig.BLOCK_SIZE + GlobalConfig.TOP_BOUNDARY - GlobalConfig.BLOCK_SIZE / 2;

	return Vector2(position.x, nearest_y);

func nearest_bottom_block(position: Vector2): # return null if no block on the bottom
	#convert position to matrix
	var x = round((position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;
	var y = round((position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE)) - 1;

	if(x > GlobalConfig.ROW - 1 || x < 0 || y > GlobalConfig.COL - 1 || y < 0):
		return null;

	var matrix = blocks_to_matrix();
	var nearest = null;
	for i in range(y + 1, GlobalConfig.COL):
		if matrix[x][i] != null:
			nearest = i;
			break;
	if nearest == null:
		return null;
	#convert back to Vector2
	var nearest_y = (nearest + 1) * GlobalConfig.BLOCK_SIZE + GlobalConfig.TOP_BOUNDARY - GlobalConfig.BLOCK_SIZE / 2;

	return Vector2(position.x, nearest_y);
