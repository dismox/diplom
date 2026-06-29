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
		%MistakeLabel.text = "Неверный тип фигуры"
		%MistakeWindow.show()
		return false

	if data.base_type != "polygon":
		%MistakeLabel.text = "Неверное основание фигуры"
		%MistakeWindow.show()
		return false

	if data.base_params.get("sides") != 6:
		%MistakeLabel.text = "Неверное основание фигуры"
		%MistakeWindow.show()
		return false

	if !is_equal_approx(data.base_params.get("radius"), 4.0):
		%MistakeLabel.text = "Неверное основание фигуры"
		%MistakeWindow.show()
		return false

	if !is_equal_approx(data.height, 8.0):
		%MistakeLabel.text = "Неверные параметры фигуры"
		%MistakeWindow.show()
		return false

	if data.get("tilt", Vector2.ZERO) != Vector2.ZERO:
		%MistakeLabel.text = "Неверный наклон фигуры"
		%MistakeWindow.show()
		return false

	return true
	
func check_stage_2(data: Dictionary) -> bool:
	if data.type != "prism":
		%MistakeLabel.text = "Неверный тип фигуры"
		%MistakeWindow.show()
		return false

	if data.base_type != "rectangle":
		%MistakeLabel.text = "Неверное основание фигуры"
		%MistakeWindow.show()
		return false

	if (data.base_params.get("width") != 4.0 and data.base_params.get("depth") != 10.0) and (data.base_params.get("width") != 10.0 and data.base_params.get("depth") != 4.0):
		%MistakeLabel.text = "Неверные параметры фигуры"
		%MistakeWindow.show()
		return false

	if !is_equal_approx(data.height, 10.0):
		%MistakeLabel.text = "Неверные параметры фигуры"
		%MistakeWindow.show()
		return false

	if data.get("tilt", Vector2.ZERO) != Vector2.ZERO:
		%MistakeLabel.text = "Неверный наклон фигуры"
		%MistakeWindow.show()
		return false

	return true


func _check_stage_3(hex_transform: Transform3D, rect_transform: Transform3D, eps_dir := 0.01, eps_pos := 0.05) -> bool:
	# направление прямоугольной призмы в плоскости основания
	var dir := rect_transform.basis.x
	dir.y = 0
	if dir.length() == 0:
		return false
	dir = dir.normalized()

	# допустимые направления, параллельные граням правильного шестиугольника
	var hex_dirs := [
		Vector3(1, 0, 0),
		Vector3(0.5, 0, sqrt(3) / 2),
		Vector3(-0.5, 0, sqrt(3) / 2)
	]

	var parallel := false
	for d in hex_dirs:
		if abs(dir.dot(d)) > 1.0 - eps_dir:
			parallel = true
			break
	if !parallel:
		return false

	# ось прямоугольной призмы проходит через центр шестиугольной в плоскости XZ
	var delta := rect_transform.origin - hex_transform.origin
	var delta_xz := Vector2(delta.x, delta.z)
	if delta_xz.length() > eps_pos:
		return false

	return true


func get_main_axis(t: Transform3D) -> Vector3:
		var axes = [t.basis.x, t.basis.y, t.basis.z]
		var max_len := 0.0
		var main := Vector3.ZERO
		for a in axes:
			var l = a.length()
			if l > max_len:
				max_len = l
				main = a
		return main.normalized()

func check_stage_3(hex_t: Transform3D, rect_t: Transform3D, eps_pos := 1.5, eps_deg := 1.0) -> bool:
	# 1. Центры фигур должны совпадать (ось проходит через центр)
	var delta := rect_t.origin - hex_t.origin
	if Vector2(delta.x, delta.z).length() > eps_pos:
		return false

	# 2. Угол поворота прямоугольной призмы относительно шестиугольной в плоскости XZ
	var hex_forward := hex_t.basis.z.normalized()
	var rect_forward := rect_t.basis.z.normalized()

	hex_forward.y = 0
	rect_forward.y = 0

	if hex_forward.length() == 0 or rect_forward.length() == 0:
		return false

	hex_forward = hex_forward.normalized()
	rect_forward = rect_forward.normalized()

	var angle := rad_to_deg(acos(clamp(hex_forward.dot(rect_forward), -1.0, 1.0)))
	angle = fposmod(angle, 180.0) # симметрия прямоугольника

	# допустимые углы: кратные 30°
	return abs(angle - round(angle / 30.0) * 30.0) < eps_deg
	

func _on_check_result_pressed() -> void:
	match level.stage:
		1:
			if check_stage_1(current_data):
				%Stage1Figure.mesh = BaseShapeBuilder.create_mesh(current_data)
				%Stage1Figure.show()
				level.stage += 1
			else:
				level.mistakes += 1
				print("Неверное решение")
				return
		2:
			if check_stage_2(current_data):
				#%Stage2Figure.mesh = BaseShapeBuilder.create_mesh(current_data)
				#%Stage2Figure.show()
				level.stage += 1
				%FigureControl.show()
				#%TestFigure.hide()
			else:
				level.mistakes += 1
				print("Неверное решение")
				return
		3:
			if check_stage_3(%Stage1Figure.global_transform, %TestFigure.global_transform):
				%Timer.stop()
				%LevelEnding.show_results()
				%LevelEnding.show()
			else:
				level.mistakes += 1
				print("Неверное решение")
				return
		_:
			return


func _on_button_pressed() -> void:
	%MistakeWindow.hide()
