extends RichTextLabel

@onready var camera = $"../../Camera"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	# Label is relative to the center point of the camera.
	var cpos2d: Vector2 = camera.global_position - Vector2(160, 90)
	var cpos3d: Vector3 = Vector3(cpos2d.x, cpos2d.y, camera.camera_zpos) 
	text = "(%.1f, %.1f, %.1f)" % [cpos3d.x, cpos3d.y, cpos3d.z]
