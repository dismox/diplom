extends Control

var current_state: UIState

func _ready() -> void:
	Global.main_screen = self

enum UIState {
	AUTORISATION,
	CHAPTER_SELECTION,
	TASK_SELECTION,
	TASK_DESCRIPTION,
	TASK,
}

func _on_back_button_pressed() -> void:
	if %LevelPreviewContainer.visible:
		%LevelPreviewContainer.hide()
		for table_line in %LeaderTable.get_children():
			if table_line != %LeaderTable.get_child(0):
				table_line.queue_free()
		return
	%LevelSelect.hide()
	%ChaptersContainer.show()
	%BackButton.hide()


func _on_start_button_pressed() -> void:
	var scene = load("res://level.tscn").instantiate()
	add_child(scene)
	hide()
	#get_tree().change_scene_to_file("res://level.tscn")
