extends VBoxContainer


func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		%LevelSelect.show()
		%BackButton.show()
		%ChaptersContainer.hide()
