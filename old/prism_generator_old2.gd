extends BaseShapeGenerator
class_name PrismGeneratorOld2

static func generate(data: Dictionary) -> Mesh:
	var base := _generate_base(data)
	var height: float = data.height
	var tilt: Vector2 = data.get("tilt", Vector2.ZERO)

	return _build_prism_mesh(base, height, tilt)
	
static func _generate_base(data: Dictionary) -> Array:
	var result := []
	var p = data.base_params

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

		"polygon", "circle":
			var sides = p.get("sides", 32)
			var r = p.radius
			for i in sides:
				var a = TAU * i / sides
				result.append(Vector3(cos(a)*r, 0, sin(a)*r))

	return result
	
static func _build_prism_mesh(base: Array, height: float, tilt: Vector2) -> Mesh:
	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()

	var index := 0
	var top_offset := Vector3(tilt.x, height, tilt.y)
	
	for i in base.size():
		var j := (i + 1) % base.size()

		var v0 = base[i]
		var v1 = base[j]
		var v2 = base[j] + top_offset
		var v3 = base[i] + top_offset

		# нормаль грани
		var normal = (v1 - v0).cross(v3 - v0).normalized()

		# 4 вершины грани
		vertices.append_array([v0, v1, v2, v3])
		normals.append_array([normal, normal, normal, normal])

		# 2 треугольника
		indices.append_array([
			index, index+1, index+2,
			index, index+2, index+3
		])

		index += 4
		
		
	var center_bottom := Vector3.ZERO
	for v in base:
		center_bottom += v
	center_bottom /= base.size()

	for i in base.size():
		var j := (i + 1) % base.size()

		var v0 = base[j]
		var v1 = base[i]
		var v2 = center_bottom

		vertices.append_array([v0, v1, v2])
		normals.append_array([
			Vector3.DOWN,
			Vector3.DOWN,
			Vector3.DOWN
		])

		indices.append_array([
			index, index+1, index+2
		])

		index += 3
		
		
	var center_top := center_bottom + top_offset

	for i in base.size():
		var j := (i + 1) % base.size()

		var v0 = base[i] + top_offset
		var v1 = base[j] + top_offset
		var v2 = center_top

		vertices.append_array([v0, v1, v2])
		normals.append_array([
			Vector3.UP,
			Vector3.UP,
			Vector3.UP
		])

		indices.append_array([
			index, index+1, index+2
		])

		index += 3
		
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	return mesh
