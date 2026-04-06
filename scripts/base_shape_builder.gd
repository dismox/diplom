extends Node
class_name BaseShapeBuilder

static func create_mesh(data: Dictionary) -> Mesh:
	match data.type:
		"prism":
			return PrismGenerator.generate(data)
		"pyramid":
			return PyramidGenerator.generate(data)
		"ellipsoid":
			return EllipsoidGenerator.generate(data)
		_:
			push_error("Неизвестный тип фигуры")
			return null
