extends Node2D

static func traverse_matrix(matrix, start_x, start_y, current_band):
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

static func set_matrix_for_visting(raw_matrix):
	var matrix: Array[Array] = [];
	for i in range(GlobalConfig.ROW):
		var cols = [];
		for j in range(GlobalConfig.COL):
			if raw_matrix[i][j] != null:
				var clone = raw_matrix[i][j].duplicate();
				clone.visited = false;
				cols.append(clone);
			else:
				cols.append(null);
		matrix.append(cols);
	return matrix;
