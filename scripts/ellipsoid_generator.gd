extends RefCounted
class_name EllipsoidGenerator

static func generate(data: Dictionary) -> Mesh:
	var height: float = data.height
	var width: float = data.height
	var depth: float = data.height
	
	if data.has("base_params"):
		width= data.base_params.get("width", height)
		depth = data.base_params.get("depth", height)

	#var width: float
	#if data.width:
	#	width = data.width
	#else:
	#	width = height

	#var depth: float
	#if data.depth:
	#	depth = data.depth
	#else:
	#	depth = height

	var lat_segments: int = data.get("segments_lat", 32)
	var lon_segments: int = data.get("segments_lon", 48)

	var rx = width * 0.5
	var ry = height * 0.5
	var rz = depth * 0.5

	var y_offset = height * 0.5

	var vertices := PackedVector3Array()
	var normals := PackedVector3Array()
	var indices := PackedInt32Array()

	for i in lat_segments + 1:
		var theta = PI * i / lat_segments

		for j in lon_segments + 1:
			var phi = TAU * j / lon_segments

			var x = sin(theta) * cos(phi)
			var y = cos(theta)
			var z = sin(theta) * sin(phi)

			var vx = rx * x
			var vy = ry * y + y_offset
			var vz = rz * z

			vertices.append(Vector3(vx, vy, vz))

			var nx = x / rx
			var ny = y / ry
			var nz = z / rz

			normals.append(Vector3(nx, ny, nz).normalized())

	var cols = lon_segments + 1

	for i in lat_segments:
		for j in lon_segments:
			var a = i * cols + j
			var b = a + cols

			indices.append_array([
				a, b, a + 1,
				b, b + 1, a + 1
			])

	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	return mesh
