extends Control

@export var playButton: Button
@export var highScoreLabel: Label

func _ready() -> void:
	get_tree().paused = false
	var save_file = FileAccess.open("user://blurp.save", FileAccess.READ)
	if save_file:
		var line = save_file.get_line()
		var json = JSON.new()
		var parsed = json.parse(line)
		if parsed == OK:
			highScoreLabel.text = str(int(json.data["highScore"]))

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_scene.tscn")
