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
	if await login_process():
		hide()
		%ChaptersContainer.show()
		%User.show()
	#else:
	#	message.text += "\nНе удалось войти в аккаунт"

func login_process() -> bool:
	message.text = ""
	
	successful_connection = true
	
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
		await check_login()
		
	return successful_connection

func check_login():
	await http_request.request(Global.url, [], HTTPClient.METHOD_GET)
	

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 0:
		message.text += "\nПривышено время ожидания ответа"
		successful_connection = false
	else:
		successful_connection = true
