extends Control

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
		"tilt": Vector2(0.0, 0.0)
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
