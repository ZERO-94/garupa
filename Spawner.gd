extends Node2D

class_name Spawner

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const CharacterBlock = preload("res://src/characters/common/CharacterBlock.gd");

var CHARACTERS = [
	"roselia/Sayo",
	"roselia/Ako",
	"roselia/Rinko",
	"roselia/Lisa",
	"roselia/Yukina",
	"popipa/Kasumi",
	"popipa/Arisa",
	"popipa/Rimi",
	"popipa/Saaya",
	"popipa/Tae",
	"afterglow/Ran",
	"afterglow/Moca",
	"afterglow/Himari",
	"afterglow/Tomoe",
	"afterglow/Tsugumi",
	"pasupare/Aya",
	"pasupare/Hina",
	"pasupare/Chisato",
	"pasupare/Maya",
	"pasupare/Eve",
]
var available_characters = CHARACTERS.duplicate();

var size = 64;


func _init(block_size = null):
	if block_size != null:
		size = block_size;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func create_block() -> CharacterBlock:
	print(available_characters.size());
	var index = randi() % available_characters.size();
	var character = available_characters[index];
	available_characters.remove_at(index);
	var new_block: CharacterBlock = load("res://blocks/characters/" + character + ".tscn").instantiate() as CharacterBlock;
	#make the block upside down
	
	new_block.name = character.split("/")[1];
	new_block.position = Vector2(position.x + size / 2, position.y  + size / 2);
	new_block.rotate(PI);

	return new_block;

func append_characters(characters: Array[String]) -> void:
	for character in characters:
		if not available_characters.has(character):
			available_characters.append(character);
	available_characters.shuffle();

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
