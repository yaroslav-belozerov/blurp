extends Node2D

@export var spawnFreq = 0.01
@export var reach = 100
@export var target: Node2D

var currentTimeout = spawnFreq
var enemy = preload("res://entities/enemy/enemy.tscn")
var s: RectangleShape2D

func _ready() -> void:
	s = $Area2D/CollisionShape2D.shape

func _process(delta: float) -> void:
	currentTimeout -= delta
	if currentTimeout < 0:
		var instance = enemy.instantiate()
		var x = s.size.x
		var y = s.size.y
		instance.global_position = position + Vector2((randf() - 0.5) * x, (randf() - 0.5) * y)
		instance.start_follow(target)
		add_sibling(instance)
		currentTimeout = spawnFreq
