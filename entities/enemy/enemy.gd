extends RigidBody2D

@export var speed = 100
@export var maxHealth = 10.0
@export var healthBar: ProgressBar
@export var gracePeriod = 0.5
var hurtSound = preload("res://resources/sounds/hit.wav")
var gracePeriodLeft = 0
var direction: Node2D
var tiles: TileMapLayer
var health: float

func _ready() -> void:
	health = maxHealth
	
func _process(delta: float) -> void:
	healthBar.value = health / maxHealth * 100
	
	gracePeriodLeft -= delta
	
	if health <= 0:
		die()

func _physics_process(delta: float) -> void:
	var tilePos = tiles.local_to_map(tiles.to_local(global_position))
	var currentTile = tiles.get_cell_tile_data(tilePos)
	if currentTile:
		var is_slow = currentTile.get_custom_data("is_slow")
		var is_poison = currentTile.get_custom_data("is_poison")
		if is_poison:
			health -= 1 * delta
		move_and_collide(position.direction_to(direction.position) * speed * (0.1 if is_slow == true else 1.0) * delta)
	else:
		move_and_collide(position.direction_to(direction.position) * speed * delta)
	$AnimatedSprite2D.play("run")
	$AnimatedSprite2D.flip_h = position.direction_to(direction.position).x < 0

func kill(onDead: Callable, damage: int) -> void:
	if gracePeriodLeft <= 0:
		health -= damage
		gracePeriodLeft = gracePeriod
	if health <= 0:
		if onDead:
			onDead.call()
		die()

func die() -> void:
	$AnimationPlayer.play("die")
	$AnimatedSprite2D.play("default")
	
func destroy() -> void:
	queue_free()

func init(follow: Node2D, tileMapLayer: TileMapLayer) -> void:
	direction = follow
	tiles = tileMapLayer
	
