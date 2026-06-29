extends Node3D

var stage: int = 1:
	set(value):
		stage = value
		%StageLabel.text = "Этап %s/3" % value
		%TaskLabel.text = tasks[value - 1]
var result

var score: int = 100
var mistakes: int = 0
var final_time: int
var level_id = "69cbb2961f768a0b56710ab8"

var tasks: Array[String] = [
	"Создайте призму, в основании которой лежит шестиугольник со стороной = 4. Высота призмы относится к стороне основания как 2:1 (Стороны правильного шестиугольника равны радиусу описаной окружности)",
	"Создайте призму с прямоугольником в основании со сторонами 4 и 10, и высотой равной наибольшей стороне",
	"Соединить две призмы так, чтобы: 
	\n- Прямоугольная призма проходила сквозь шестиугольную\n- Ось прямоугольной призмы параллельна двум противоположным боковым граням шестиугольной призмы",
	""
]


func _ready() -> void:
	%Timer.start()

func get_score() -> int:
	var result = 10000 - 1000 * mistakes - int(%Timer.time_elapsed)
	return result


func _on_button_pressed() -> void:
	%UIController.current_data = {
		"type": "ellipsoid",
		"height": 1.5,
	}
	
	%UIController.update_figure()
	
func _on_button_2_pressed() -> void:
	%UIController.current_data = {
	"type": "pyramid",
	"base_type": "polygon", # rectangle | polygon | circle
	"base_params": {
		"width": 2.0,
		"depth": 2.0,
		"sides": 5,
		"radius": 0.25,
	},
	"height": 0.3,
	"apex_offset": Vector2(0.5, 0.0)
	}
	
	%UIController.update_figure()


func _on_button_3_pressed() -> void:
	pass # Replace with function body.
