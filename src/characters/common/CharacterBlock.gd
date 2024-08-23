extends Node2D

const BlockNode = preload("res://src/characters/common/BlockNode.gd");

var SINGLE_BLOCK_SIZE = GlobalConfig.BLOCK_SIZE;
const BLOCK_NODE_NAME = "BlockNode";

func _ready():
	pass # Replace with function body.

func rotate_char():
	#check if hit boundary
	global_rotation_degrees += 90;

func revert_rotate_char():
	global_rotation_degrees -= 90;

func move_down(steps: int = 1):
	position.y += steps * SINGLE_BLOCK_SIZE;

func move_right():
	position.x += SINGLE_BLOCK_SIZE;

func move_left():
	position.x -= SINGLE_BLOCK_SIZE;

func get_block_nodes() -> Array[BlockNode]:
	var arr: Array[BlockNode] = [];
	var nodes = get_children();
	for node in nodes:
		if(node.name.begins_with(BLOCK_NODE_NAME)):
			arr.append(node);
	return arr;

func get_bottom_nodes() -> Array[BlockNode]:
	var nodes = get_block_nodes();
	var bottom_nodes: Array[BlockNode] = [];
	for node in nodes:
		var is_bottom = true;
		var block_matrix_position = node.get_matrix_position();
		for other_node in nodes:
			var b_matrix_position = other_node.get_matrix_position();
			if node == other_node or b_matrix_position.x != block_matrix_position.x: 
				continue;
			if block_matrix_position.y + 1 == b_matrix_position.y:
				is_bottom = false;
				break;
		if is_bottom:
			bottom_nodes.append(node as BlockNode);
	return bottom_nodes;

func is_landed_on_node(below_node_position: Vector2):
	if below_node_position == null:
		return false;
	var nodes = get_block_nodes();
	for n in nodes:
		if round(n.global_position.x) == round(below_node_position.x) and round(n.global_position.y) + SINGLE_BLOCK_SIZE == round(below_node_position.y):
			return true;
	return false

func get_band() -> String :
	var groups = get_groups();
	for group in groups:
		if group.begins_with("band"):
			return group.split(":")[1];
	return ""