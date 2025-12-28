extends Area2D

@export var speed: float
var direction: Vector2 
var callOnHit: Callable

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func init(pos: Vector2, dir: Vector2, onHit: Callable) -> void:
	position = pos
	direction = dir
	callOnHit = onHit

func _physics_process(delta):
	position += direction * delta * speed


func _on_body_entered(body: Node) -> void:
	if body.has_method("local_to_map"):
		$AnimationPlayer.play("explode")
	if body.is_in_group("enemy") and body.has_method("kill"):
		$AnimationPlayer.play("explode")
		body.kill(callOnHit, 10)
