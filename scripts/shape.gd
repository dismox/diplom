extends Node
class_name Shape

var type: Type
var base_type: BaseType
var height: float
var tilt: Vector2

var width: float
var depth: float
var radius: float
var sides: int


enum Type {
	PRISM,
	PYRAMID,
}

enum BaseType {
	CIRCLE,
	RECTANGE,
	POLYGON,
}
