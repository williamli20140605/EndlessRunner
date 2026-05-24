extends Node2D

const DISTANCE_SCALE := 10.0
const MAX_LIVES := 2
const DEATH_GOLD_KEEP_RATE := 0.45
const BASE_SCROLL_SPEED := 220.0
const RECOVERY_SECTIONS_AFTER_HIT := 1

var random := RandomNumberGenerator.new()
var player

var is_started := false
var score := 0.0
var best_score := 0.0
var gold := 0
var total_gold := 0
var lives := MAX_LIVES
var run_time := 0.0
var run_distance := 0.0
var scroll_speed := BASE_SCROLL_SPEED
var has_shield := false

@onready var world: Node2D = $World
@onready var background: Node2D = $Background
@onready var canvas: CanvasLayer = $CanvasLayer
@onready var easter_egg: Area2D = $World/EasterEgg
@onready var scroll_layer: Node2D = $World/Scrollers
@onready var hills_layer: Node2D = $Background/Hills
@onready var clouds_layer: Node2D = $Background/Clouds

func _ready() -> void:
	random.randomize()
	canvas.setup_world(background, world, scroll_layer, random)
	world.coin_collected.connect(_on_coin_collected)
	world.shield_collected.connect(_on_shield_collected)
	world.player_died.connect(game_over)
	world.player_hurt.connect(_on_player_hurt)
	world.player_jumped.connect(_on_player_jumped)
	world.player_landed.connect(_on_player_landed)
	start_game()

func start_game() -> void:
	world.clear_run()

	is_started = true
	score = 0.0
	gold = 0
	run_time = 0.0
	run_distance = 0.0
	lives = MAX_LIVES
	scroll_speed = BASE_SCROLL_SPEED
	has_shield = false
	Engine.time_scale = 1.0
	background.position = Vector2.ZERO
	world.position = Vector2.ZERO

	canvas.show_run()
	canvas.reset_screen_motion()
	easter_egg.reset()

	player = world.start_run(random)
	_update_hud()

func _process(delta: float) -> void:
	if not is_started:
		return

	delta = minf(delta, 0.05)
	var step := scroll_speed * delta
	run_time += delta
	run_distance += step
	score = run_distance / DISTANCE_SCALE
	world.update_run(delta, scroll_speed, run_distance, run_time, has_shield)
	if not is_started:
		return
	_update_parallax(delta)
	canvas.update_screen_motion(delta)
	_update_hud()

func _on_coin_collected(value: int, position: Vector2) -> void:
	if not is_started:
		return

	gold += value
	_update_hud()

func _on_shield_collected(position: Vector2) -> void:
	if not is_started:
		return

	has_shield = true
	canvas.add_shake(2.0, 0.10)
	_update_hud()

func _on_easter_egg_collected(position: Vector2) -> void:
	if not is_started:
		return

	gold *= 2
	canvas.show_message("Easter Egg!\nGold x2")
	canvas.add_shake(4.0, 0.12)
	_update_hud()

func _on_player_hurt() -> void:
	if not is_started:
		return

	canvas.show_message("Hit")
	world.set_recovery_sections(RECOVERY_SECTIONS_AFTER_HIT)
	if has_shield:
		has_shield = false
		_hit_stop()
		canvas.add_shake(5.0, 0.15)
		_update_hud()
		return

	lives -= 1
	if lives <= 0:
		if is_instance_valid(player):
			player.die()
		else:
			game_over()
		return

	_hit_stop()
	canvas.add_shake(7.0, 0.18)
	_update_hud()

func _update_parallax(delta: float) -> void:
	_scroll_layer(clouds_layer, delta, 0.22, 260.0)
	_scroll_layer(hills_layer, delta, 0.45, 480.0)

func _scroll_layer(layer: Node2D, delta: float, speed_factor: float, sprite_width: float) -> void:
	for child in layer.get_children():
		child.position.x -= scroll_speed * speed_factor * delta
		if child.position.x < -sprite_width * 0.5:
			child.position.x += sprite_width * layer.get_child_count()

func _on_player_jumped(position: Vector2, first_jump: bool) -> void:
	var dust_count := 3
	var shake_strength := 1.0
	if first_jump:
		dust_count = 5
		shake_strength = 0.7

	canvas.spawn_dust(position + Vector2(-10.0, -4.0), dust_count, Color(0.88, 0.78, 0.58, 0.62))
	canvas.add_shake(shake_strength, 0.04)

func _on_player_landed(position: Vector2) -> void:
	canvas.spawn_dust(position + Vector2(-8.0, -2.0), 6, Color(0.86, 0.76, 0.55, 0.68))

func game_over() -> void:
	if not is_started:
		return

	is_started = false
	if is_instance_valid(player):
		player.set_physics_process(false)

	if score > best_score:
		best_score = score

	var kept_gold := _get_death_banked_gold()
	var lost_gold := maxi(gold - kept_gold, 0)
	total_gold += kept_gold

	Engine.time_scale = 1.0
	canvas.show_game_over(int(score), kept_gold, lost_gold, total_gold)
	_update_hud()

func _get_death_banked_gold() -> int:
	return int(floor(float(gold) * DEATH_GOLD_KEEP_RATE))

func _hit_stop() -> void:
	Engine.time_scale = 0.65
	var tween := create_tween()
	tween.set_ignore_time_scale(true)
	tween.tween_interval(0.08)
	tween.tween_callback(Callable(self, "_restore_time_scale"))

func _restore_time_scale() -> void:
	if is_started:
		Engine.time_scale = 1.0

func _update_hud() -> void:
	canvas.update_hud(
		int(score),
		int(best_score),
		gold,
		lives,
		MAX_LIVES,
		has_shield
	)

func _on_restart_button_pressed() -> void:
	start_game()
