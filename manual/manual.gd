extends Control

class_name Manual

@export var current_tab: ManualTab
@export var all_tabs: Array[ManualTab]

var on_screen: bool = true

func _ready() -> void:
	$TextureRect/TabsHBoxContainer/TabPanel.articles = [$TextureRect/ManualPageLeft/Article1]
	$TextureRect/TabsHBoxContainer/TabPanel2.articles = [$TextureRect/ManualPageLeft/Article2, $TextureRect/ManualPageLeft/Article3, $TextureRect/ManualPageRight/Article4]
	$TextureRect/TabsHBoxContainer/TabPanel3.articles = [$TextureRect/ManualPageLeft/Article2, $TextureRect/ManualPageLeft/Article4]


func show_articles(articles: Array):
	for child in %ManualPageLeft.get_children():
		child.hide()
	for child in %ManualPageRight.get_children():
		child.hide()
	for article in articles:
		article.show()

func _input(event):
	if event.is_action_pressed("manual"):
		if on_screen:
			$AnimationPlayer.play("hide_manual")
		else:
			$AnimationPlayer.play("show_manual")
		on_screen = !on_screen


func _on_rich_text_label_meta_hover_started(meta: Variant) -> void:
	%Tooltip.position = get_global_mouse_position() + Vector2(10.0, 10.0)
	%Tooltip.show()
	$AnimationPlayer.play("show_tooltip")


func _on_rich_text_label_meta_hover_ended(meta: Variant) -> void:
	%Tooltip.hide()
