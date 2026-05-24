extends Area2D
class_name ShieldPickup

signal collected(position: Vector2)

var is_collected := false
var animation_offset := 0.0

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	animation_offset = randf() * TAU
	body_entered.connect(_on_body_entered)

func _process(_delta: float) -> void:
	var progress := Time.get_ticks_msec() * 0.0055 + animation_offset
	sprite.position.y = sin(progress) * 3.0
	sprite.scale = Vector2.ONE * (0.92 + absf(sin(progress * 0.8)) * 0.12)

func _on_body_entered(body: Node) -> void:
	if is_collected:
		return
	if not body.is_in_group("runner"):
		return

	is_collected = true
	collected.emit(global_position)
	queue_free()
