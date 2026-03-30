extends Control

@onready var http_request: HTTPRequest = %HTTPRequest

@onready var levels_grid_container: GridContainer = %LevelsGridContainer
@onready var level_button: Button = %LevelButton
@onready var leader_table: VBoxContainer = %LeaderTable

var levels_count: int = 27

func _ready() -> void:
	fill_levels_grid()
	
func fill_levels_grid() -> void:
	for i in range(levels_count):
		var new_button = level_button.duplicate(true)
		new_button.text = str(i + 2)
		levels_grid_container.add_child(new_button)


func _on_level_button_pressed() -> void:
	%LevelPreviewContainer.show()
	#тут бы еще информацию уровня загружать
	fill_level_preview()
	
func fill_level_preview():
	
	#тестовые данные
	var data_array = [
		{ "name": "name1", "score": "1", "time": "00:00" },
		{ "name": "name2", "score": "42", "time": "01:15" }
	]
	
	#указать правильный url
	#как-то передавать айди уровня нужного пока не знаю как
	await http_request.request("http://192.168.56.1:80/...", ["Content-Type: application/json"], HTTPClient.METHOD_GET)
	
	for item in data_array:
		var name = str(item.get("name", "?"))
		var score = str(item.get("score", "0"))
		var time = str(item.get("time", "00:00"))
		
		var table_line: TableLine = load("res://table_line.tscn").instantiate()
		leader_table.add_child(table_line)
		table_line.set_values(name, time, score)
