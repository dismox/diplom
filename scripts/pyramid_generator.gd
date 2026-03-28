extends BaseShapeGenerator
class_name PyramidGenerator

static func generate(data: Dictionary) -> Mesh:
	var gen := PyramidGenerator.new()
	gen._build(data)
	return gen.build_mesh()
	
func _build(data: Dictionary) -> void:
	var base := _generate_base(data)
	var height: float = data.height
	var apex_offset = data.get("apex_offset", Vector2.ZERO)

	# вершина пирамиды
	var apex := Vector3(
		apex_offset.x,
		height,
		apex_offset.y
	)

	# --- БОКОВЫЕ ГРАНИ ---
	for i in base.size():
		var j := (i + 1) % base.size()
		add_triangle(
			base[i],
			base[j],
			apex
		)

	# --- ОСНОВАНИЕ ---
	var center := Vector3.ZERO
	for v in base:
		center += v
	center /= base.size()

	for i in base.size():
		var j := (i + 1) % base.size()
		# порядок важен → нормаль вниз
		add_triangle(
			base[j],
			base[i],
			center
		)
		

func _generate_base(data: Dictionary) -> Array:
	var p = data.base_params
	var result := []

	match data.base_type:
		"rectangle":
			var w = p.width * 0.5
			var d = p.depth * 0.5
			result = [
				Vector3(-w, 0, -d),
				Vector3( w, 0, -d),
				Vector3( w, 0,  d),
				Vector3(-w, 0,  d)
			]

		"polygon":
			var sides = p.get("sides", 3)
			var r = p.radius
			for i in sides:
				var a = TAU * i / sides
				result.append(Vector3(cos(a)*r, 0, sin(a)*r))
				
		"circle":
			var sides = 100
			var r = p.radius
			for i in sides:
				var a = TAU * i / sides
				result.append(Vector3(cos(a)*r, 0, sin(a)*r))

	return result
