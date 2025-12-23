extends RigidBody2D

@export var speed = 400
@export var dashLength = 500
@export var maxHealth = 100
@export var healthBar: ProgressBar
@export var pointsLabel: Label
@export var finalPanel: Panel
@export var finalPointsLabel: Label
@export var gracePeriod = 0.1
var gracePeriodLeft = 1
var laser = preload("res://entities/laser/laser.tscn")
var laserInstance: Node2D
var dashProgress = 0
var health: int
var vel = Vector2.ZERO
var points = 0
var isDead = false

func _ready() -> void:
	health = maxHealth

func _process(delta: float) -> void:
	healthBar.value = float(health) / maxHealth * 100
	pointsLabel.text = str(points)
	
	if health <= 0:
		isDead = true
		
	if isDead:
		get_tree().paused = true
		finalPanel.visible = true
		finalPointsLabel.text = str(points)
		return
	
	if Input.is_action_just_pressed("shoot"):
		shoot(get_node("."))
	if Input.is_action_just_released("shoot"):
		if laserInstance:
			laserInstance.free()
			
	gracePeriodLeft -= delta
	
	if Input.is_action_just_pressed("dash") && dashProgress <= 0:
		set_collision_mask_value(3, false)
		dashProgress = 1.0
	else:
		if dashProgress <= 0:
			dashProgress = 0
			set_collision_mask_value(3, true)
		else:
			dashProgress -= 0.1

func _physics_process(delta):
	vel = Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		vel.y -= 1
	if Input.is_action_pressed("move_down"):
		vel.y += 1
	if Input.is_action_pressed("move_right"):
		vel.x += 1
	if Input.is_action_pressed("move_left"):
		vel.x -= 1
	vel = vel.normalized() * speed
	
	var body = move_and_collide((vel*delta).lerp((vel*delta*dashLength)*delta, dashProgress))
	if body:
		var collider = body.get_collider()
		if collider.is_in_group("enemy") and collider.has_method("kill"):
			collider.kill()
			if gracePeriodLeft <= 0:
				health -= 1
				gracePeriodLeft = gracePeriod

func hitEnemy() -> void:
	points += 100

func shoot(andFollow: Node2D) -> void:
	laserInstance = laser.instantiate()
	laserInstance.global_position = position
	laserInstance.look_at(get_global_mouse_position())
	laserInstance.init(andFollow, hitEnemy)
	add_sibling(laserInstance)
