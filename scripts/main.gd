extends Node3D

#func _ready():
	#var mesh := BaseShapeBuilder.create_mesh(shape_data2)
	#%TestFigure.mesh = mesh

func _on_button_pressed() -> void:
	var shape_data = {
		"type": "prism",
		"base_type": "circle", # rectangle | polygon | circle
		"base_params": {
			"width": 1.0,
			"depth": 1.5,
			#"sides": 5,
			"radius": 0.5,
		},
		"height": 2.0,
		"tilt": Vector2(1.0, 0.0)
	}
	
	var mesh := BaseShapeBuilder.create_mesh(shape_data)
	%TestFigure.mesh = mesh
	


func _on_button_2_pressed() -> void:
	var shape_data = {
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
	
	var mesh := BaseShapeBuilder.create_mesh(shape_data)
	%TestFigure.mesh = mesh
