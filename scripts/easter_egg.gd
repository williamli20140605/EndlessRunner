extends Area2D

signal collected(position: Vector2)

var is_used := false
var start_position := Vector2.ZERO

func _ready() -> void:
	start_position = position
	body_entered.connect(_on_body_entered)

func reset() -> void:
	is_used = false
	position = start_position

func _on_body_entered(body: Node) -> void:
	if is_used:
		return
	if not body.is_in_group("runner"):
		return

	is_used = true
	collected.emit(global_position)
