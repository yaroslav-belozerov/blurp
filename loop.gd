extends Node2D

@export var player: Node2D
@export var pauseMenu: Panel
@export var gameOverMenu: Panel
@export var difficultyProgress: ProgressBar
@export var maxDifficulty = 6.0
@export var difficultyStep = 0.03
var isPaused = false
@export var initialDifficulty = 0.7
var difficulty: float

func _ready() -> void:
	difficulty = initialDifficulty
	get_tree().paused = false

func _process(delta: float) -> void:
	difficultyProgress.value = (difficulty - initialDifficulty) / maxDifficulty * 100
	gameOverMenu.visible = player.isDead
	pauseMenu.visible = isPaused && !player.isDead
	get_tree().paused = isPaused || player.isDead
	if difficulty < maxDifficulty:
		difficulty += difficultyStep * delta
		
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("pause"):
		if player.isDead:
			player.savePoints()
			get_tree().change_scene_to_file("res://main_menu.tscn")
		else:
			isPaused = !isPaused
