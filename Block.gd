extends Node2D

var block_size = 64;

func _ready():
	pass # Replace with function body.

func rotate_block(left: int, right: int, bottom: int, top: int):
	#check if hit boundary
	var blocks = get_blocks();
	global_rotation_degrees += 90;
	for block in blocks:
		var position = block.global_position;
		var threshold = block_size / 2;
		if position.x <= left - threshold or position.x >= right + threshold or position.y >= bottom + threshold or position.y <= top - threshold:
			global_rotation_degrees -= 90;
			return;
	
func move_down():
	position.y += block_size;

func move_right(right_boundary: int):
	var blocks = get_blocks();
	for block in blocks:
		if block.global_position.x + block_size >= right_boundary:
			return;
	position.x += block_size;

func move_left(left_boundary: int):
	var blocks = get_blocks();
	for block in blocks:
		if block.global_position.x - block_size <= left_boundary:
			return;
	position.x -= block_size;

func get_blocks() -> Array: # returns an array of KinematicBody2D in group "block"
	var children = get_children();
	var blocks = [];
	for child in children:
		if child.is_in_group("block"):
			blocks.append(child);
	return blocks;

func is_landed(boundary: int):
	var blocks = get_blocks();
	for block in blocks:
		if block.global_position.y >= boundary - block_size / 2:
			return true;
	return false;

func is_landed_on_block(below_block: Vector2):
	if below_block == null:
		return false;
	var blocks = get_blocks();
	for b in blocks:
		if b.global_position.x == below_block.x and b.global_position.y == below_block.y:
			return true;
	return false;

func is_collided(position: Vector2):
	var blocks = get_blocks();
	for block in blocks:
		if block.position.x == position.x and block.position.y == position.y:
			return true;
	return false;
