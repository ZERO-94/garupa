extends Node2D

const SINGLE_BLOCK_SIZE = 64;

func _ready():
	pass # Replace with function body.

func rotate_char(left: int, right: int, bottom: int, top: int):
	#check if hit boundary
	global_rotation_degrees += 90;
	var blocks = get_blocks();
	for block in blocks:
		var position = block.global_position;
		var threshold = SINGLE_BLOCK_SIZE / 2;
		if position.x <= left - threshold or position.x >= right + threshold or position.y >= bottom + threshold or position.y <= top - threshold:
			global_rotation_degrees -= 90;
			return;
	
func move_down():
	position.y += SINGLE_BLOCK_SIZE;

func move_right(right_boundary: int):
	var blocks = get_blocks();
	for block in blocks:
		if block.global_position.x + SINGLE_BLOCK_SIZE >= right_boundary:
			return;
	position.x += SINGLE_BLOCK_SIZE;

func move_left(left_boundary: int):
	var blocks = get_blocks();
	for block in blocks:
		if block.global_position.x - SINGLE_BLOCK_SIZE <= left_boundary:
			return;
	position.x -= SINGLE_BLOCK_SIZE;

func get_blocks() -> Array: # returns an array of CharacterBody2D in group "block"
	var children = get_children();
	var blocks = [];
	for child in children:
		if child.is_in_group("block"):
			blocks.append(child);
	return blocks;

func get_bottom_blocks():
	var blocks = get_blocks();
	var bottom_blocks = [];
	for block in blocks:
		var is_bottom = true;
		for b in blocks:
			if block != b and round(block.global_position.x) == round(b.global_position.x) and round(block.global_position.y) + SINGLE_BLOCK_SIZE == round(b.global_position.y):
				is_bottom = false;
				break;
		if is_bottom:
			bottom_blocks.append(block);
	return bottom_blocks;

func is_landed(boundary: int):
	var blocks = get_blocks();
	for block in blocks:
		if round(block.global_position.y) >= boundary - SINGLE_BLOCK_SIZE / 2:
			return true;
	return false;

func is_landed_on_block(below_block: Vector2):
	if below_block == null:
		return false;
	var blocks = get_blocks();
	var is_landed = false;
	for b in blocks:
		if round(b.global_position.x) == round(below_block.x) and round(b.global_position.y) + SINGLE_BLOCK_SIZE == round(below_block.y):
			is_landed = true;
			break;
	return is_landed;

func is_collided(position: Vector2):
	var blocks = get_blocks();
	for block in blocks:
		if block.position.x == position.x and block.position.y == position.y:
			return true;
	return false;
