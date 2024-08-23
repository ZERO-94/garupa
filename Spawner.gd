extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var CHARACTERS = [
	"roselia/Sayo",
	"roselia/Ako",
	"roselia/Rinko",
	"roselia/Lisa",
	"roselia/Yukina",
	"popipa/Kasumi",
	"popipa/Arisa",
	"popipa/Rimi",
	"popipa/Saya",
	"popipa/OTae",
	"afterglow/Ran",
	"afterglow/Moca",
	"afterglow/Himari",
	"afterglow/Tomoe",
	"afterglow/Tsugumi",
]
var available_characters = CHARACTERS;
var spawned_characters = [];

var size = 64;


func _init(block_size = null):
	if block_size != null:
		size = block_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_block(ref) -> Node2D:
	var character = available_characters[randi() % available_characters.size()];
	spawned_characters.append(character);
	available_characters.erase(character);
	var new_block = load("res://blocks/characters/" + character + ".tscn").instantiate();
	#make the block upside down
	
	new_block.name = character.split("/")[1];
	new_block.position = Vector2(position.x + size / 2, position.y  + size / 2);
	new_block.rotate(PI);

	ref.add_child(new_block);
	return new_block;

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
