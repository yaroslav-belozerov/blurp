extends Camera2D

@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shakeStrength: float = 0.0

func _ready() -> void:
	pass

func shake(strength: float) -> void:
	shakeStrength = strength 

func _process(delta: float) -> void:
	if shakeStrength > 0:
		shakeStrength =  lerpf(shakeStrength,0,shakeFade*delta)
		offset = randomOffset()
	
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength))
