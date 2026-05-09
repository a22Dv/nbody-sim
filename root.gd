extends Node2D

@export var initial_velo: float = 0
@export var initial_mass: float = 10
@export var initial_rotation: float = 0
@onready var cursorlabel := $CursorLabel
@onready var cursord_arrow := $CursorDirectionArrow

var body := load("res://body.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("VelocityDown"):
		initial_velo = clamp(initial_velo - 1, 0, 25)
	elif event.is_action_pressed("VelocityUp"):
		initial_velo = clamp(initial_velo + 1, 0, 25)
	elif event.is_action_pressed("MassDown"):
		initial_mass = clamp(initial_mass - 50, 10, 1000)
	elif event.is_action_pressed("MassUp"):
		initial_mass = clamp(initial_mass + 50, 10, 1000)
	elif event.is_action_pressed("RotationCCW"):
		initial_rotation = fmod(initial_rotation - 0.1, 2 * PI)
	elif event.is_action_pressed("RotationCW"):
		initial_rotation = fmod(initial_rotation + 0.1, 2 * PI)
	elif event.is_action_pressed("SpawnBody"):
		var nbody: Node2D = body.instantiate()
		var wvx: float = initial_velo * cos(initial_rotation)
		var wvy: float = initial_velo * sin(initial_rotation)
		add_child(nbody)
		
		nbody.global_position = get_global_mouse_position()
		nbody.global_rotation = initial_rotation
		nbody.mass = initial_mass
		nbody.velocity = Vector2(wvx, wvy)
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var mpos := get_global_mouse_position()
	cursorlabel.global_position = mpos + Vector2(5, 5)
	cursorlabel.text = "INIT_MASS: %.2f units\nINIT_VELO: %.2f m/s^2\nINIT_ROT: %.2f DEG" % [initial_mass, initial_velo, -initial_rotation * 180 / PI]
	cursord_arrow.global_position = mpos + Vector2(10, 0).rotated(initial_rotation)
	cursord_arrow.global_rotation = initial_rotation
	initial_velo = clamp(initial_velo, 0, 25)
	initial_rotation = fmod(initial_rotation, 2 * PI)
	
	var weightv := 1 - initial_velo / 25.0
	cursord_arrow.modulate = Color.from_hsv(lerp(0.0, 0.3, weightv), 1, 1)
	cursord_arrow.scale = Vector2(1.5 - weightv, 1.5 - weightv)
	
