extends RigidBody2D

var follow: Node2D
var callOnHit: Callable

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if follow != null:
		position = follow.position
		look_at(get_global_mouse_position())

func init(node: Node2D, onHit: Callable) -> void:
	follow = node
	callOnHit = onHit 

func _physics_process(delta):
	for body in get_colliding_bodies():
		if body.is_in_group("enemy") and body.has_method("kill"):
			callOnHit.call()
			body.kill()
