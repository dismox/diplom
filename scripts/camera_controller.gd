extends Node3D

@export var camera: Camera3D
@export var test_figure: Node3D

@export var zoom_speed := 1.0
@export var min_distance := 1.0
@export var max_distance := 90.0

@export var pan_speed := 0.005

@export var rotation_speed := 0.01

var _right_mouse := false
var _left_mouse := false
var _last_mouse_pos := Vector2.ZERO


func _ready() -> void:
	if camera == null:
		camera = $Camera3D
	if test_figure == null:
		test_figure = %TestFigure


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_right_mouse = event.pressed
			_last_mouse_pos = event.position

		elif event.button_index == MOUSE_BUTTON_LEFT:
			_left_mouse = event.pressed
			_last_mouse_pos = event.position

		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_zoom(-zoom_speed)

		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_zoom(zoom_speed)

	elif event is InputEventMouseMotion:
		var delta = event.position - _last_mouse_pos
		_last_mouse_pos = event.position

		if _right_mouse:
			_pan(delta)

		if _left_mouse:
			_rotate_figure(delta.x)



func _zoom(amount: float) -> void:
	var dir := camera.transform.basis.z.normalized()
	var dist := camera.position.length()
	dist = clamp(dist + amount, min_distance, max_distance)
	camera.position = dir * dist


func _pan(delta: Vector2) -> void:
	var right := camera.global_transform.basis.x
	var forward := camera.global_transform.basis.z

	var move = (right * delta.x + forward * delta.y) * pan_speed

	global_position -= Vector3(move.x, 0.0, move.z)


func _rotate_figure(delta_x: float) -> void:
	if test_figure:
		test_figure.rotate_y(-delta_x * rotation_speed)
