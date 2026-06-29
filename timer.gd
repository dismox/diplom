extends Node

var time_elapsed: float = 0.0
var running: bool = false

func _process(delta: float) -> void:
	if running:
		time_elapsed += delta
		update_label()

func start() -> void:
	running = true

func stop() -> void:
	running = false

func reset() -> void:
	time_elapsed = 0.0
	update_label()

func update_label() -> void:
	self.text = get_time_string()

func get_time_string() -> String:
	var minutes := int(time_elapsed) / 60
	var seconds := int(time_elapsed) % 60
	var milliseconds := int((time_elapsed - int(time_elapsed)) * 100)
	
	var text: String = "%02d:%02d.%02d" % [minutes, seconds, milliseconds]
	return text
	
