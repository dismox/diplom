extends PanelContainer

class_name ManualTab

@export var manual: Manual
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var tab_title: Label = %TabTitle

var opened: bool = false
var articles = []

func _on_mouse_entered() -> void:
	animation_player.play("show_characters")
	for tab in manual.all_tabs:
		if tab != self:
			tab.tab_title.visible_ratio = 0

func _on_mouse_exited() -> void:
	if manual.current_tab != self:
		animation_player.play_backwards("show_characters")


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		manual.show_articles(articles)
		manual.current_tab = self
