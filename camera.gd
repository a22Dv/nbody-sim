extends Camera2D

var z_velocity: float = 0
var z_inertia: float = 0

@export var camera_zspeed: float = 10
@export var camera_zpos: float = 1
@export var camera_zposmax: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_held_inputs(delta)

func _physics_process(delta: float) -> void:
	handle_camera(delta)
	
func handle_camera(delta: float) -> void:
	# How much of the current speed is preserved across ticks.
	const velocity_decay: float = 0.93
	const inertia_decay: float = 0.1
	z_inertia *= inertia_decay
	z_velocity *= velocity_decay
	
	z_velocity += z_inertia * delta
	
	#  
	camera_zpos = clamp(camera_zpos + z_velocity, 0.5, camera_zposmax)

	# S_app / S_real (1) = 1 / z_pos
	var scale_apparent: float = 1 / camera_zpos
	zoom = Vector2(scale_apparent, scale_apparent)
	
## Left=0, Right=1, Up=2, Down=3
func move_camera(direction: int, delta: float) -> void:
	assert(direction < 6, "Invalid direction.")
	const speed: float = 400

	match direction:
		0: global_position += Vector2.LEFT * speed * delta 
		1: global_position += Vector2.RIGHT * speed * delta
		2: global_position += Vector2.UP * speed * delta
		3: global_position += Vector2.DOWN * speed * delta
		
		# Core zoom logic is handled in `handle_camera()` for smoothing.
		4: z_inertia = -max(abs(z_inertia) + delta * camera_zspeed, camera_zspeed)
		5: z_inertia = max(abs(z_inertia) + delta * camera_zspeed, camera_zspeed)
		_: assert(false, "Unreachable.")

func handle_held_inputs(delta: float) -> void:
	const cam_actions = {
		"MoveLeft" : 0,
		"MoveRight" : 1,
		"MoveUp" : 2,
		"MoveDown" : 3,
		"ZoomIn": 4,
		"ZoomOut": 5
	}
	for k in cam_actions.keys():
		if Input.is_action_pressed(k):
			move_camera(cam_actions[k], delta)
			
	
	
		
