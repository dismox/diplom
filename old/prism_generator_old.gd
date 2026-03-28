extends BaseShapeGenerator
class_name PrismGeneratorOLD

static func generate(data: Dictionary) -> Mesh:
	var height: float = data.height
	var tilt: Vector2 = data.get("tilt", Vector2.ZERO)

	var base_vertices = _generate_base(data)

	var st = SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)

	var top_offset = Vector3(tilt.x, height, tilt.y)

	# --- БОКОВЫЕ ГРАНИ ---
	for i in base_vertices.size():
		var next := (i + 1) % base_vertices.size()

		var v0 = base_vertices[i]
		var v1 = base_vertices[next]
		var v2 = base_vertices[next] + top_offset
		var v3 = base_vertices[i] + top_offset

		# первый треугольник
		st.add_vertex(v0)
		st.add_vertex(v1)
		st.add_vertex(v2)

		# второй треугольник
		st.add_vertex(v0)
		st.add_vertex(v2)
		st.add_vertex(v3)

	# --- НИЖНЯЯ КРЫШКА ---
	_add_cap(st, base_vertices, false)

	# --- ВЕРХНЯЯ КРЫШКА ---
	var top_vertices := []
	for v in base_vertices:
		top_vertices.append(v + top_offset)

	_add_cap(st, top_vertices, true)

	st.generate_normals(false)
	return st.commit()


static func _generate_base(data: Dictionary) -> Array:
	var result = []
	var base_type = data.base_type
	var p = data.base_params
	
	match base_type:
		"rectangle":
			var w = p.width * 0.5
			var d = p.depth * 0.5
			
			result = [
				Vector3(-w, 0, -d),
				Vector3(w, 0, -d),
				Vector3(w, 0, d),
				Vector3(-w, 0, d)
			]
		
		"circle":
			var radius = p.radius
			var sides = p.get("sides", 32)
			
			for i in sides:
				var angle = TAU * i / sides
				result.append(Vector3(cos(angle) * radius, 0, sin(angle) * radius))
		
		"polygon":
			var sides = p.sides
			var radius = p.radius
			
			for i in sides:
				var angle = TAU * i / sides
				result.append(Vector3(cos(angle) * radius, 0, sin(angle) * radius))
	
	return result


static func _add_cap(st: SurfaceTool, vertices: Array, invert: bool) -> void:
	var center := Vector3.ZERO
	for v in vertices:
		center += v
	center /= vertices.size()

	for i in vertices.size():
		var next := (i + 1) % vertices.size()

		if invert:
			st.add_vertex(vertices[i])
			st.add_vertex(vertices[next])
			st.add_vertex(center)
		else:
			st.add_vertex(vertices[next])
			st.add_vertex(vertices[i])
			st.add_vertex(center)
