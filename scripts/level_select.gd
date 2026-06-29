extends Control

@onready var http_request: HTTPRequest = %HTTPRequest

@onready var levels_grid_container: HFlowContainer = %LevelsGridContainer
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
	
	#как-то передавать айди уровня нужного пока не знаю как, но пока наверное вручную вставить просто
	var level_id = "69cbb2961f768a0b56710ab8"
	await http_request.request("http://192.168.56.1:80/tasks/" + level_id + "/leaderboard", ["Content-Type: application/json"], HTTPClient.METHOD_GET)



	#тестовые данные
	var data_array = [
		{ "name": "Someone", "score": "69", "time": "01:00" },
		{ "name": "Student", "score": "42", "time": "01:15" }
	]
	
		
	for item in data_array:
		var name = str(item.get("name", "?"))
		var score = str(item.get("score", "0"))
		var time = str(item.get("time", "00:00"))
		
		var table_line: TableLine = load("res://table_line.tscn").instantiate()
		leader_table.add_child(table_line)
		table_line.set_values(name, time, score)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 0 and %TableMessage:
		print("Привышено время ожидания ответа")
		%TableMessage.text = "Привышено время ожидания ответа"
		%TableMessage.show()
		
	elif response_code == 200:
		var json_string = body.get_string_from_utf8()
		var data = JSON.parse_string(json_string)
		
		for item in data:
			var name = str(item.get("name", "?"))
			var score = str(int(item.get("score", "0")))
			var time = str(item.get("completeTime", "00:00"))
			
			var table_line: TableLine = load("res://table_line.tscn").instantiate()
			leader_table.add_child(table_line)
			table_line.set_values(name, time, score)
	else:
		print(body.get_string_from_utf8())
