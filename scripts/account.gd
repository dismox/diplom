extends Control
class_name Account

@onready var http_request: HTTPRequest = %HTTPRequest

@onready var name_label: Label = %NameLabel
@onready var account_level_label: Label = %AccountLevelLabel

@onready var account_info_container: PanelContainer = %AccountInfoContainer

@onready var registration_date_label: Label = %RegistrationDateLabel
@onready var tasks_label: Label = %TasksLabel
@onready var achivments_label: Label = %AchivmentsLabel


func _on_user_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		account_info_container.visible = !account_info_container.visible
		

func request_account_info() -> void:
	#указать правильный url с Global.accessToken
	await http_request.request("http://192.168.56.1:80/users", ["Content-Type: application/json", "authorization: " + Global.accessToken], HTTPClient.METHOD_GET)


func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 0:
		#хз пока как обработать
		return
	elif response_code == 200:
		var json_string = body.get_string_from_utf8()
		var user_data = JSON.parse_string(json_string)
		print(user_data)
		name_label.text = user_data.get("name", "Неизвестно")
		registration_date_label.text = "Дата регистрации: " + user_data.get("registrationDate", "Неизвестно")
		tasks_label.text = "Пройдено заданий: " + str(int(user_data.get("completedTasksNumber", "Неизвестно")))
		achivments_label.text = "Достижения: " +  user_data.get("achivmentsNames", "Неизвестно")
	else:
		return
		#обработка ошибок
		#message.text = body.get_string_from_utf8()
