extends Node
class_name WebConnector

#var url = "https://api.github.com/repos/godotengine/godot/releases/latest"
@export var url = "26.192.36.247:3000/users"

@export var http_request: HTTPRequest

func _ready() -> void:
	send_request()

func send_request():
	var headers = ["Contetn-Type: application/json"]
	http_request.request(url, headers, HTTPClient.METHOD_GET)
	#http_request.request("https://api.github.com/repos/godotengine/godot/releases/latest")

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 0:
		print("Привышено время ожидания ответа")
	else:
		var json = JSON.parse_string(body.get_string_from_utf8())
		#print(json["name"])
