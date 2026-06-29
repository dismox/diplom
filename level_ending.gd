extends PanelContainer


func _on_button_pressed() -> void:
	$MarginContainer/VBoxContainer/Label.text = "Ожидание"
	
	var url := "http://192.168.56.1:80/users"

	var headers := [
		"Content-Type: application/json; charset=utf-8",
		"Authorization: " + str(Global.accessToken)
	]

	var body_dict := {
		"completedTasks": {
			"TaskName": "69cbb2961f768a0b56710ab8",
			"completeTime": 50,
			"score": 100
		}
	}
	
	var body_json := JSON.stringify(body_dict)

	var err = %HTTPRequest.request(url, headers, HTTPClient.METHOD_PUT, body_json)
	if err != OK:
		push_error("HTTP request error: %s" % err)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	var body_text := body.get_string_from_utf8()

	if response_code == 0:
		print("Привышено время ожидания ответа")
		$MarginContainer/VBoxContainer/Label.text = "Привышено время ожидания ответа"

	if response_code == 200:
		var json = JSON.parse_string(body_text)
		print("Response:", body_text)
		print(json)
		
		Global.main_screen.show()
		Global.main_screen._on_back_button_pressed()
		Global.main_screen
		$"..".queue_free()
