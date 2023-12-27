extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var CHARACTERS = ["roselia_Ako", "roselia_Sayo", "roselia_Rinko", "roselia_Lisa", "roselia_Yukina"];
var stored_characters = CHARACTERS;
var spawned_characters = [];

var size = 64;


func _init(block_size = null):
	if block_size != null:
		size = block_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_block(ref):
	# if(stored_characters.size() == 0):
	# 	return null;
	# var index = randi() % stored_characters.size();

	# var character = stored_characters[randi() % stored_characters.size()];
	# spawned_characters.append(character);
	# stored_characters.erase(character);
	# var new_block = load("res://blocks/" + character.replace("_", "/") + ".tscn").instance();
	var new_block = load("res://blocks/common/Block.tscn").instance();
	#make the block upside down
	
	new_block.name = "block_" + String(OS.get_system_time_msecs());
	new_block.position = Vector2(position.x + size / 2, position.y  + size / 2);
	new_block.rotate(PI);



	ref.add_child(new_block);
	return new_block;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
