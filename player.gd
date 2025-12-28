extends RigidBody2D

@export var speed = 400
@export var dashLength = 500
@export var maxHealth = 100
@export var healthBar: ProgressBar
@export var energyBar: ProgressBar
@export var pointsLabel: Label
@export var finalPanel: Panel
@export var finalPointsLabel: Label
@export var gracePeriod = 0.1
@export var pointsPerEnemy = 100
@export var maxEnergy: int
var gracePeriodLeft = 0
var laser = preload("res://entities/laser/laser.tscn")
var bomb = preload("res://entities/bomb/bomb.tscn")
var hurtSound = preload("res://resources/sounds/player_hit.wav")
var laserInstance: Node2D
var dashProgress = 0
var vel = Vector2.ZERO
var points = 0
var isDead = false
var health: float
var energy = 0

func updatePoints(points: int):
	pointsLabel.text = str(points)

func getTween() -> Tween:
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.set_trans(Tween.TRANS_EXPO)
	return tween

func _ready() -> void:		
	health = maxHealth
	healthBar.value = 100

func savePoints() -> void:
	var read_save_file = FileAccess.open("user://blurp.save", FileAccess.READ)
	var highScore = 0
	if read_save_file:
		var line = read_save_file.get_line()
		var json = JSON.new()
		var parsed = json.parse(line)
		if parsed == OK:
			highScore = int(json.data["highScore"])
	if highScore < points:
		var save_file = FileAccess.open("user://blurp.save", FileAccess.WRITE)
		var save_str = JSON.stringify({"highScore": points})
		save_file.store_line(save_str)

func _process(delta: float) -> void:
	energyBar.value = float(energy) / maxEnergy * 100
	
	if health <= 0:
		if !isDead:
			savePoints()
		isDead = true
		
	if isDead:
		finalPanel.visible = true
		finalPointsLabel.text = str(points)
		return
	
	if Input.is_action_just_pressed("bomb") && energy == maxEnergy:
		energy = 0
		var inst = bomb.instantiate()
		inst.init(position, position.direction_to(get_global_mouse_position()), hitEnemy)
		add_sibling(inst)
		
	if Input.is_action_just_released("shoot"):
		if laserInstance:
			laserInstance.destroy()
	if Input.is_action_just_pressed("shoot"):
		shoot(get_node("."))
			
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
	
	if gracePeriodLeft > 0:
		$AnimationPlayer.play("damage")
	else:
		$AnimationPlayer.play("RESET")
	if vel.length() > 0:
		$AnimatedSprite2D.flip_h = vel.x < 0
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("default")	
	
	vel = vel.normalized() * speed
	var collision = move_and_collide((vel*delta).lerp((vel*delta*dashLength)*delta, dashProgress))
	for body in get_colliding_bodies() + ([collision.get_collider()] if collision else []):
		if body && body.has_method("is_in_group") && body.is_in_group("enemy"):
			damage()

func damage() -> void:
	if gracePeriodLeft <= 0 && dashProgress <= 0:
		var cam = get_viewport().get_camera_2d()
		if cam && cam.has_method("shake"):
			cam.shake(10.0)
		$AudioStreamPlayer2D.playing = true
		health -= 1
		gracePeriodLeft = gracePeriod
		getTween().tween_property(healthBar, "value", health / maxHealth * 100, 0.2)

func hitEnemy() -> void:
	getTween().tween_method(updatePoints, points, points + pointsPerEnemy, 0.2)
	points += pointsPerEnemy
	energy = min(energy + 1, maxEnergy)

func shoot(andFollow: Node2D) -> void:
	laserInstance = laser.instantiate()
	laserInstance.global_position = position
	laserInstance.look_at(get_global_mouse_position())
	laserInstance.init(andFollow, hitEnemy)
	add_sibling(laserInstance)
