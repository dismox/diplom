extends Node3D


func _on_button_pressed() -> void:
	%UIController.current_data = {
		"type": "ellipsoid",
		"height": 1.5,
	}
	
	%UIController.update_figure()
	

func _on_button_2_pressed() -> void:
	%UIController.current_data = {
	"type": "pyramid",
	"base_type": "polygon", # rectangle | polygon | circle
	"base_params": {
		"width": 2.0,
		"depth": 2.0,
		"sides": 5,
		"radius": 0.25,
	},
	"height": 0.3,
	"apex_offset": Vector2(0.5, 0.0)
	}
	
	%UIController.update_figure()


func _on_button_3_pressed() -> void:
	pass # Replace with function body.
