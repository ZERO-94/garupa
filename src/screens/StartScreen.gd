extends Node2D

var start_button: Button = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CenterContainer/StartGameButton.connect("pressed", self._on_start_button_pressed);
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_start_button_pressed():
	ScreenTransition.change_scene("res://screens/GameScreen.tscn");
	pass;
