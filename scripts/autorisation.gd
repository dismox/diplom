extends PanelContainer

var login: String
var password: String

var successful_connection: bool

@onready var username_edit: LineEdit = %UsernameEdit
@onready var password_edit: LineEdit = %PasswordEdit
@onready var message: Label = %Message
@onready var http_request: HTTPRequest = %HTTPRequest

func _on_login_button_pressed() -> void:
	#проверка авторизации
	login_process()
	#else:
	#	message.text += "\nНе удалось войти в аккаунт"

func login_process() -> bool:
	message.text = ""
	
	successful_connection = false
	
	login = username_edit.text
	password = password_edit.text
	
	if login.is_empty():
		message.text += "\nВведите имя пользователя"
		successful_connection = false
	if password.is_empty():
		message.text += "\nВведите пароль"
		successful_connection = false
	
	if login and password:
		#запрос
		check_login()
		
	return successful_connection

func check_login():
	var data = {
		"name": login, 
		"password": password
		}
	var json = JSON.stringify(data, "\t")
	print(json)
	await http_request.request("http://192.168.56.1:80/users/login", ["Content-Type: application/json"], HTTPClient.METHOD_POST, json)
	

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	
	if response_code == 0:
		message.text += "\nПривышено время ожидания ответа"
		successful_connection = false
	elif response_code == 200:
		#successful_connection = true
		hide()
		%ChaptersContainer.show()
		%User.show()
	else:
		message.text = body.get_string_from_utf8()
