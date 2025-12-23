extends RigidBody2D

@export var speed = 100
var direction: Node2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	move_and_collide(position.direction_to(direction.position) * speed * delta)

func kill() -> void:
	$AnimationPlayer.play("die")
	
func destroy() -> void:
	queue_free()

func start_follow(node: Node2D) -> void:
	direction = node
