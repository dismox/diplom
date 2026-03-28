extends RefCounted
class_name BaseShapeGenerator

var vertices: PackedVector3Array
var normals: PackedVector3Array
var indices: PackedInt32Array
var _index: int

func add_quad(v0: Vector3, v1: Vector3, v2: Vector3, v3: Vector3) -> void:
	var normal := (v1 - v0).cross(v3 - v0).normalized()

	vertices.append_array([v0, v1, v2, v3])
	normals.append_array([normal, normal, normal, normal])

	indices.append_array([
		_index, _index + 1, _index + 2,
		_index, _index + 2, _index + 3
	])

	_index += 4
	
func add_triangle(v0: Vector3, v1: Vector3, v2: Vector3) -> void:
	var normal := (v1 - v0).cross(v2 - v0).normalized()

	vertices.append_array([v0, v1, v2])
	normals.append_array([normal, normal, normal])

	indices.append_array([
		_index, _index + 1, _index + 2
	])

	_index += 3
	
func build_mesh() -> Mesh:
	var arrays := []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_NORMAL] = normals
	arrays[Mesh.ARRAY_INDEX] = indices

	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	return mesh
