extends PanelContainer

@onready var username_edit: LineEdit = %UsernameEdit
@onready var password_edit: LineEdit = %PasswordEdit
@onready var message: Label = %Message
@onready var http_request: HTTPRequest = %HTTPRequest

func _on_login_button_pressed() -> void:
	#проверка авторизации
	login_process()

func login_process() -> void:
	message.text = ""
	
	var login = username_edit.text
	var password = password_edit.text
	
	if login.is_empty():
		message.text += "\nВведите имя пользователя"
	if password.is_empty():
		message.text += "\nВведите пароль"
	
	if login and password:
		#запрос
		check_login()


func check_login() -> void:
	var data = {
		"name": username_edit.text, 
		"password": password_edit.text
		}
	var json = JSON.stringify(data, "\t")
	print(json)
	await http_request.request(Global.url + "/users/login", ["Content-Type: application/json"], HTTPClient.METHOD_POST, json)
	

func _on_http_request_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 0:
		message.text += "\nПривышено время ожидания ответа"
		
	elif response_code == 200:
		var json_string = body.get_string_from_utf8()
		var data = JSON.parse_string(json_string)
		Global.accessToken = data.accessToken
		#Global.accessToken = data.get("accessToken", "?") #Другой вариант если тот не работает
		%Account.request_account_info()
		%Account.show()
		%ChaptersContainer.show()
		hide()
		
	else:
		message.text = body.get_string_from_utf8()
