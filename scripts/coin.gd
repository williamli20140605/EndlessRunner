extends Area2D
class_name CoinPickup

signal collected(value: int, position: Vector2)

var value := 1

var is_collected := false
var animation_offset := 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	animation_offset = randf() * TAU
	if value > 1:
		sprite.modulate = Color(1.0, 0.72, 0.28, 1.0)
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	var progress := Time.get_ticks_msec() * 0.006 + animation_offset
	var flip := 0.62 + absf(sin(progress)) * 0.38
	sprite.scale = Vector2(flip, 1.0)
	sprite.position.y = sin(progress * 0.7) * 1.8

func _on_body_entered(body: Node) -> void:
	if is_collected:
		return
	if not body.is_in_group("runner"):
		return

	is_collected = true
	collected.emit(value, global_position)
	queue_free()
