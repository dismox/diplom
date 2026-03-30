extends Control


func _on_back_button_pressed() -> void:
	if %LevelPreviewContainer.visible:
		%LevelPreviewContainer.hide()
		for table_line in %LeaderTable.get_children():
			table_line.queue_free()
		return
	%LevelSelect.hide()
	%ChaptersContainer.show()
	%BackButton.hide()



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://level.tscn")
