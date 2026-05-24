extends StaticBody2D
class_name GroundSegment

var is_solid := true

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func configure(solid: bool) -> void:
	is_solid = solid
	visible = solid
	collision_shape.disabled = not solid
	collision_layer = 1 if solid else 0
	collision_mask = 1 if solid else 0

func contains_x(world_x: float) -> bool:
	return absf(world_x - global_position.x) <= 100.0
