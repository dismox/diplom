extends Control

@onready var figure: CSGMesh3D = %TestFigure

func _on_up_pressed() -> void:
	figure.position.z -= 0.2


func _on_down_pressed() -> void:
	figure.position.z += 0.2


func _on_left_pressed() -> void:
	figure.position.x -= 0.2


func _on_right_pressed() -> void:
	figure.position.x += 0.2


func _on_rot_right_pressed() -> void:
	figure.rotation.y += deg_to_rad(5)


func _on_rot_left_pressed() -> void:
	figure.rotation.y -= deg_to_rad(5)


func _on_up_2_pressed() -> void:
	figure.position.y += 0.1


func _on_down_2_pressed() -> void:
	figure.position.y -= 0.1
