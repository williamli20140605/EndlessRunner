extends Area2D

var vertical_motion := 0.0
var vertical_speed := 0.0

var start_y := 0.0
var animation_offset := 0.0

func _ready() -> void:
	start_y = position.y
	animation_offset = randf() * TAU

func set_vertical_motion(amount: float, speed: float) -> void:
	vertical_motion = amount
	vertical_speed = speed

func _process(_delta: float) -> void:
	if vertical_motion <= 0.0:
		return

	var progress := Time.get_ticks_msec() * 0.001 * vertical_speed + animation_offset
	position.y = start_y + sin(progress) * vertical_motion
