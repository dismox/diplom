extends Control

@onready var level = $"../.."
var current_data = {
		"type": "prism",
		"base_type": "rectangle",
		"base_params": {
			"width": 1.0,
			"depth": 1.0,
			"sides": 6,
			"radius": 1.5,
		},
		"height": 1.0,
		"tilt": Vector2(0.0, 0.0),
		"subtract": false
	}


var stage_1_target := {
	"type": "prism",
	"base_type": "polygon",
	"base_params": {
		"sides": 6,
		"radius": 4.0
	},
	"height": 8.0,
	"tilt": Vector2.ZERO
}

var stage_2_target := {
		"type": "prism",
		"base_type": "rectangle",
		"base_params": {
			"width": 4.0,
			"depth": 12.0,
		},
		"height": 10.0,
		"tilt": Vector2(0.0, 0.0),
	}



func update_figure():
	var mesh := BaseShapeBuilder.create_mesh(current_data)
	%TestFigure.mesh = mesh


func _on_pyramid_button_pressed() -> void:
	current_data.type = "pyramid"
	update_figure()

func _on_prism_button_pressed() -> void:
	current_data.type = "prism"
	update_figure()
	
func _on_ellipsoid_button_pressed() -> void:
	current_data.type = "ellipsoid"
	update_figure()


func _on_rectangle_button_pressed() -> void:
	current_data.base_type = "rectangle"
	update_figure()

func _on_polygon_button_pressed() -> void:
	current_data.base_type = "polygon"
	update_figure()

func _on_circle_button_pressed() -> void:
	current_data.base_type = "circle"
	update_figure()


func _on_height_edit_value_changed(value: float) -> void:
	current_data.height = value
	update_figure()


func _on_tilt_x_edit_value_changed(value: float) -> void:
	current_data.tilt.x = value
	update_figure()

func _on_tilt_y_edit_value_changed(value: float) -> void:
	current_data.tilt.y = value
	update_figure()


func _on_width_edit_value_changed(value: float) -> void:
	current_data.base_params.width = value
	update_figure()

func _on_depth_edit_value_changed(value: float) -> void:
	current_data.base_params.depth = value
	update_figure()


func _on_sides_edit_value_changed(value: int) -> void:
	current_data.base_params.sides = value
	update_figure()

func _on_radius_edit_value_changed(value: float) -> void:
	current_data.base_params.radius = value
	update_figure()






func check_stage_1(data: Dictionary) -> bool:
	if data.type != "prism":
		return false

	if data.base_type != "polygon":
		return false

	if data.base_params.get("sides") != 6:
		return false

	if !is_equal_approx(data.base_params.get("radius"), 4.0):
		return false

	if !is_equal_approx(data.height, 8.0):
		return false

	if data.get("tilt", Vector2.ZERO) != Vector2.ZERO:
		return false

	return true
	
func check_stage_2(data: Dictionary) -> bool:
	if data.type != "prism":
		return false

	if data.base_type != "rectangle":
		return false

	if (data.base_params.get("width") != 4.0 and data.base_params.get("depth") != 10.0) and (data.base_params.get("width") != 10.0 and data.base_params.get("depth") != 4.0):
		return false

	if !is_equal_approx(data.height, 10.0):
		return false

	if data.get("tilt", Vector2.ZERO) != Vector2.ZERO:
		return false

	return true
	
	
	
func _check_stage_2(data: Dictionary) -> bool:
	if data.type != "pyramid":
		return false

	if data.base_type != "polygon":
		return false

	if data.base_params.get("sides") != 3:
		return false

	if !is_equal_approx(data.height, 9.0):
		return false

	var r = data.base_params.get("radius")
	if r == null:
		return false

	var tilt = data.get("tilt", Vector2.ZERO)

	var vertices := [
		Vector2( r, 0 ),
		Vector2( -r * 0.5,  r * sqrt(3) * 0.5 ),
		Vector2( -r * 0.5, -r * sqrt(3) * 0.5 )
	]

	for v in vertices:
		if tilt.is_equal_approx(v):
			return true

	return false


func check_stage_3(prism: Dictionary, pyramid: Dictionary) -> bool:
	if prism.type != "prism":
		return false
	if pyramid.type != "pyramid":
		return false

	# Основания совпадают логически
	if prism.base_type != pyramid.base_type:
		return false

	# Центры совпадают
	if prism.get("tilt", Vector2.ZERO) != Vector2.ZERO:
		return false
	if pyramid.get("tilt", Vector2.ZERO) != Vector2.ZERO:
		return false

	# Высота пирамиды совпадает с центром призмы
	if !is_equal_approx(pyramid.height, prism.height):
		return false

	# Флаг вычитания
	if !pyramid.get("subtract", false):
		return false

	return true

func _on_check_result_pressed() -> void:
	match level.stage:
		1:
			if check_stage_1(current_data):
				%Stage1Figure.mesh = BaseShapeBuilder.create_mesh(current_data)
				%Stage1Figure.show()
				level.stage += 1
			else:
				print("Неверное решение")
				return
		2:
			if check_stage_2(current_data):
				%Stage2Figure.mesh = BaseShapeBuilder.create_mesh(current_data)
				%Stage2Figure.show()
				level.stage += 1
				%TestFigure.hide()
			else:
				print("Неверное решение")
				return
		3:
			if check_stage_3(current_data, current_data):
				level.stage += 1
			else:
				print("Неверное решение")
				return
		_:
			return
