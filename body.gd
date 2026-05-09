extends Node2D

@export var mass = 50
@export var velocity := Vector2.ZERO
@export var acceleration := Vector2.ZERO
@onready var stats := $Stats
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var accelmag := sqrt(acceleration.x ** 2 + acceleration.y ** 2)
	var velomag := sqrt(velocity.x ** 2 + velocity.y ** 2)
	global_scale = Vector2(mass / 1000.0, mass / 1000.0) * 0.5
	stats.text = "MASS: %.2f units\nACCELERATION: %.2f m/s^2\nVELOCITY: %.2f m/s" % [mass, accelmag, velomag]
	stats.position = Vector2(global_scale.x * 32 + 32, global_scale.y * 32 + 32) # 64 = Sprite size.
	stats.scale = Vector2(1, 1) / scale
	stats.rotation = -rotation
