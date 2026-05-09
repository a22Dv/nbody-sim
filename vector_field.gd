extends Node2D

@onready var camera = $"../Camera"

var varrow: Texture2D =  load("res://assets/arrow.png")
var varrow_size: Vector2i = varrow.get_size()
var arrowstats: Dictionary[Vector2i, Vector2] = {} # (Magnitude, Rotation (radians))
var arrows: Dictionary[Vector2i, Sprite2D] = {}

@export var G: float = 2
@export var tick_rate: float = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func render_field() -> void:
	# Get current bounds
	var cbounds := Rect2(camera.get_screen_center_position(), get_viewport_rect().size / camera.zoom)
	cbounds.position -= cbounds.size / 2

	var gstep: Vector2i = varrow_size * 2
	var tcols := cbounds.size.x / gstep.x + 2 as int
	var trows := cbounds.size.y / gstep.y + 2 as int
	var start: Vector2i = floor(cbounds.position / (gstep as Vector2)) as Vector2i * gstep
	
	# Spawn an arrow according to a grid starting with the top left closest to the viewport.
	for ak in arrows.keys():
		var brect := Rect2(ak, varrow_size)
		if !cbounds.encloses(brect):
			arrows[ak].queue_free()
			arrows.erase(ak)
			arrowstats.erase(ak)
			
	for i in range(trows):
		for j in range(tcols):
			var tpos: Vector2i = start + Vector2i(j * varrow_size.x * 2, i * varrow_size.y * 2)
			if tpos not in arrows:
				var sp := Sprite2D.new()
				sp.texture = varrow
				sp.global_position = tpos
				arrows[tpos] = sp
				arrowstats[tpos] = Vector2.ZERO
				add_child(sp)
				
func render_body_effects(delta: float) -> void:
	var bodies = get_tree().get_nodes_in_group("bodies")
	
	for body in bodies:
		body.acceleration = Vector2.ZERO
		
	for i in range(bodies.size()):
		var fx: float = 0
		var fy: float = 0
		var ma: float = bodies[i].mass
		for j in range(i + 1, bodies.size()):
			var mb: float = bodies[j].mass
			var pa: Vector2 = bodies[i].global_position
			var pb: Vector2 = bodies[j].global_position
			var rsq := pa.distance_to(pb) ** 2
			var angle := atan2(pb.y - pa.y, pb.x - pa.x)
			var efx := G * ma * mb * cos(angle) / rsq
			var efy := G * ma * mb * sin(angle) / rsq
			fx += efx
			fy += efy
			bodies[j].acceleration -= Vector2(efx, efy) / mb
		bodies[i].acceleration += Vector2(fx, fy) / ma
		
	for body in bodies:
		body.velocity += body.acceleration * delta
		body.global_position += body.velocity * delta
	
		
func render_field_effects() -> void:
	var bodies = get_tree().get_nodes_in_group("bodies")
	for arrow in arrowstats:
		var arrowfx: float = 0
		var arrowfy: float = 0
		
		var point_a := arrow
		for body in bodies:
			var point_b: Vector2 = body.global_position
			var mass_b: float = body.mass
			var d: float = point_a.distance_to(point_b)
			d = max(1, d)
			var dx: float = point_b.x - point_a.x
			var dy: float = point_b.y - point_a.y
			var angle: float = atan2(dy, dx)
			arrowfx += G * mass_b * cos(angle) / (d * d)
			arrowfy += G * mass_b * sin(angle) / (d * d)
						
		var astat := Vector2.ZERO
		astat.x = sqrt(arrowfx * arrowfx + arrowfy * arrowfy)
		astat.y = atan2(arrowfy, arrowfx)
		arrowstats[arrow] = astat
		
		var ascale: float = clampf(astat.x, 0.5, 1) 
		arrows[arrow].scale = Vector2(ascale, ascale)
		arrows[arrow].global_rotation = astat.y # Rotation in radians.
		
		var clampmag := clampf(astat.x, 0, 1)
		arrows[arrow].modulate = Color.from_hsv(lerpf(0.0, 0.6, 1 - clampmag), 1, 1)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	delta *= tick_rate
	render_field()
	render_body_effects(delta)
	render_field_effects()
	
	
	
	
