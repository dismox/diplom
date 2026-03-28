extends Control


func _on_back_button_pressed() -> void:
	%LevelSelectContainer.hide()
	%ChaptersContainer.show()
	%BackButton.hide()


func _on_panel_container_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
