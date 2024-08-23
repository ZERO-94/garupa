extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_matrix_position():
	var x = floor((global_position.x - GlobalConfig.LEFT_BOUNDARY) / (GlobalConfig.BLOCK_SIZE));
	var y = floor((global_position.y - GlobalConfig.TOP_BOUNDARY) / (GlobalConfig.BLOCK_SIZE));
	return Vector2(x, y);
