extends CharacterBody2D

signal died
signal hurt
signal jumped(position: Vector2, first_jump: bool)
signal landed(position: Vector2)

var gravity := 1200.0
var jump_speed := -550.0
var double_jump_speed := -500.0
var duck_jump_speed := -475.0
var duck_double_jump_speed := -425.0
var max_jumps := 2
var fall_limit_y := 720.0
var coyote_time := 0.11
var buffer_time := 0.12
var hurt_time := 1.25
var fall_multiplier := 1.62
var visual_scale := 1.18

var is_alive := true
var is_ducking := false
var jumps_used := 0
var coyote_timer := 0.0
var jump_buffer := 0.0
var hurt_timer := 0.0
var visual_squash := Vector2.ONE
var standing_shape: RectangleShape2D
var duck_shape: RectangleShape2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

func _ready() -> void:
	add_to_group("runner")
	standing_shape = RectangleShape2D.new()
	standing_shape.size = Vector2(28, 44)
	duck_shape = RectangleShape2D.new()
	duck_shape.size = Vector2(30, 26)
	modulate = Color.WHITE
	visual_squash = Vector2.ONE
	_set_ducking(false)
	sprite.play("run")

func _physics_process(delta: float) -> void:
	if not is_alive:
		return

	delta = minf(delta, 0.05)
	hurt_timer = maxf(hurt_timer - delta, 0.0)

	_update_jump_state(delta)
	_update_jump_buffer(delta)
	_set_ducking(Input.is_action_pressed("duck"))

	velocity.x = 0.0
	velocity.y += gravity * _gravity_scale() * delta

	if jump_buffer > 0.0 and _can_jump():
		_jump()

	var was_on_floor := is_on_floor()
	move_and_slide()
	if not was_on_floor and is_on_floor():
		visual_squash = Vector2(1.08, 0.94)
		landed.emit(global_position)

	if position.y > fall_limit_y:
		die()

func _process(_delta: float) -> void:
	if not is_alive:
		return

	var run_bounce := 0.0
	if is_on_floor() and not is_ducking:
		run_bounce = sin(Time.get_ticks_msec() * 0.018) * 1.2

	var sprite_y := -24.0
	if is_ducking:
		sprite_y = -17.0
	sprite.position.y = sprite_y + run_bounce
	sprite.scale = sprite.scale.lerp(visual_squash * visual_scale, 0.24)
	_update_animation()
	_update_hurt_flash()

func _update_jump_state(delta: float) -> void:
	if is_on_floor():
		jumps_used = 0
		coyote_timer = coyote_time
		return

	coyote_timer = maxf(coyote_timer - delta, 0.0)
	if coyote_timer == 0.0 and jumps_used == 0:
		jumps_used = 1

func _update_jump_buffer(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		jump_buffer = buffer_time
	else:
		jump_buffer = maxf(jump_buffer - delta, 0.0)

func _gravity_scale() -> float:
	if velocity.y > 0.0:
		return fall_multiplier
	return 1.0

func _can_jump() -> bool:
	return _has_ground_jump() or jumps_used < max_jumps

func _has_ground_jump() -> bool:
	return is_on_floor() or coyote_timer > 0.0

func _jump() -> void:
	var first_jump := _has_ground_jump()
	velocity.y = _jump_speed(first_jump)
	if first_jump:
		jumps_used = 1
	else:
		jumps_used += 1
	jump_buffer = 0.0
	coyote_timer = 0.0
	visual_squash = Vector2(0.95, 1.07)
	jumped.emit(global_position, first_jump)

func _jump_speed(first_jump: bool) -> float:
	if first_jump:
		if is_ducking:
			return duck_jump_speed
		return jump_speed

	if is_ducking:
		return duck_double_jump_speed
	return double_jump_speed

func _update_animation() -> void:
	var anim := "run"
	if is_ducking:
		anim = "duck"
	elif not is_on_floor():
		anim = "jump"

	if sprite.animation != anim:
		sprite.play(anim)

func _update_hurt_flash() -> void:
	if hurt_timer <= 0.0:
		modulate = Color.WHITE
		return

	var flash_frame := int(Time.get_ticks_msec() / 90) % 2
	if flash_frame == 0:
		modulate.a = 0.45
	else:
		modulate.a = 1.0

func _set_ducking(value: bool) -> void:
	if is_ducking == value:
		return

	is_ducking = value
	if is_ducking:
		jumps_used = 0
		collision_shape.shape = duck_shape
		collision_shape.position = Vector2(0, -13)
		visual_squash = Vector2(1.06, 0.95)
		sprite.position = Vector2(0, -17)
	else:
		collision_shape.shape = standing_shape
		collision_shape.position = Vector2(0, -22)
		visual_squash = Vector2.ONE
		sprite.position = Vector2(0, -24)

func hit_hazard() -> void:
	if not is_alive:
		return
	if hurt_timer > 0.0:
		return

	hurt_timer = hurt_time
	velocity.y = -280.0
	hurt.emit()

func die() -> void:
	if not is_alive:
		return

	is_alive = false
	velocity = Vector2.ZERO
	modulate = Color.WHITE
	sprite.play("hit")
	died.emit()
