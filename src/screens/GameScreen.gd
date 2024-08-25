extends Node2D

const CharacterBlock = preload("res://src/characters/common/CharacterBlock.gd");

func _ready():
	$Playground.new_game();

func _physics_process(delta):
	update_ui();

	if !$Playground.is_in_combo and $Playground.current_block == null:
		#update date spawner available characters before spawning new block
		for char in $Playground.spawned_chars:
			if $Spawner.available_characters.find(char) == -1:
				$Spawner.available_characters.append(char);
		var new_block = $Spawner.create_block();
		$Playground.set_current_block(new_block);

func update_ui():
	var score_label = get_node(NodePath("ScorePanel/CenterContainer/VSplitContainer/ScoreContainer/ScoreText"));
	score_label.text = str($Playground.score);
	var combo_label = get_node(NodePath("ScorePanel/CenterContainer/VSplitContainer/MaxComboContainer/MaxComboText"));
	combo_label.text = str($Playground.max_combo);
