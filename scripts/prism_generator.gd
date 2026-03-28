extends BaseShapeGenerator
class_name PrismGenerator

static func generate(data: Dictionary) -> Mesh:
	var gen := PrismGenerator.new()
	gen._build(data)
	return gen.build_mesh()
	
func _build(data: Dictionary) -> void:
	var base := _generate_base(data)
	var height = data.height
	var tilt = data.get("tilt", Vector2.ZERO)
	var top_offset := Vector3(tilt.x, height, tilt.y)

#боковые грани
	for i in base.size():
		var j := (i + 1) % base.size()
		add_quad(
			base[i],
			base[j],
			base[j] + top_offset,
			base[i] + top_offset
		)

#основание
	var center := Vector3.ZERO
	for v in base:
		center += v
	center /= base.size()

	for i in base.size():
		var j := (i + 1) % base.size()
		add_triangle(base[j], base[i], center)

#верхняя часть
	var top_center := center + top_offset
	for i in base.size():
		var j := (i + 1) % base.size()
		add_triangle(
			base[i] + top_offset,
			base[j] + top_offset,
			top_center
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
