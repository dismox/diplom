extends HBoxContainer
class_name TableLine

var user: String = "Неизвестен"
var time: String = "Неизвестно"
var score: String = "Неизвестно"
@onready var user_label: Label = %UserLabel
@onready var time_label: Label = %TimeLabel
@onready var score_label: Label = %ScoreLabel

func set_values(_user: String = "Неизвестен", _time: String = "Неизвестно", _score: String = "Неизвестно") -> void:
	user = _user
	time = _time
	score = _score
	user_label.text = user
	time_label.text = time
	score_label.text = score
