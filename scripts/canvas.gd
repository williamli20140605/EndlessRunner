extends CanvasLayer

const SHAKE_Y_RATIO := 0.65
const BACKGROUND_SHAKE_RATIO := 0.35
const SHAKE_FADE_SPEED := 8.0
const DUST_FADE_TIME := 0.32
const DUST_SIZE := Vector2(2.0, 4.0)
const DUST_SPAWN_X := Vector2(-8.0, 8.0)
const DUST_SPAWN_Y := Vector2(-2.0, 5.0)
const DUST_DRIFT_X := Vector2(-42.0, -16.0)
const DUST_DRIFT_Y := Vector2(-14.0, 6.0)
const DUST_LIFE := Vector2(0.28, 0.44)
const DUST_Z_INDEX := 18

var random: RandomNumberGenerator
var background: Node2D
var world: Node2D
var dust_layer: Node2D
var shake_time := 0.0
var shake := 0.0
var message_tween: Tween

@onready var hud_backdrop: ColorRect = $HudBackdrop
@onready var score_label: Label = $ScoreLabel
@onready var best_label: Label = $HighScoreLabel
@onready var gold_label: Label = $GoldLabel
@onready var lives_label: Label = $LivesLabel
@onready var shield_label: Label = $ShieldLabel
@onready var message_label: Label = $MessageLabel
@onready var game_over_shade: ColorRect = $GameOverShade
@onready var game_over_label: Label = $GameOverLabel
@onready var result_label: Label = $ResultLabel
@onready var restart_button: Button = $RestartButton

func setup_world(
	background_node: Node2D,
	world_node: Node2D,
	dust_node: Node2D,
	random_src: RandomNumberGenerator
) -> void:
	background = background_node
	world = world_node
	dust_layer = dust_node
	random = random_src

func show_run() -> void:
	game_over_shade.hide()
	game_over_label.text = ""
	result_label.text = ""
	restart_button.hide()
	restart_button.text = "Run Again"
	message_label.hide()
	set_run_hud_visible(true)

func show_game_over(score: int, kept_gold: int, lost_gold: int, total_gold: int) -> void:
	game_over_shade.show()
	game_over_label.text = "Run Ended"
	result_label.text = "SCORE %d KEPT %d LOST %d TOTAL %d" % [
		score,
		kept_gold,
		lost_gold,
		total_gold
	]
	set_run_hud_visible(false)
	restart_button.show()
	restart_button.text = "Run Again"
	restart_button.grab_focus()

func set_run_hud_visible(value: bool) -> void:
	hud_backdrop.visible = value
	score_label.visible = value
	best_label.visible = value
	gold_label.visible = value
	lives_label.visible = value
	shield_label.visible = value

func update_hud(
	score: int,
	best_score: int,
	gold: int,
	lives: int,
	max_lives: int,
	shield: bool
) -> void:
	score_label.text = "SCORE %d" % score
	best_label.text = "BEST %d" % best_score
	gold_label.text = "GOLD %d" % gold
	lives_label.text = "HEARTS %d/%d" % [lives, max_lives]

	if shield:
		shield_label.text = "SHIELD ON"
		shield_label.modulate = Color.WHITE
	else:
		shield_label.text = "SHIELD --"
		shield_label.modulate = Color(1.0, 1.0, 1.0, 0.58)

func show_message(text: String) -> void:
	if message_tween:
		message_tween.kill()

	message_label.text = text
	message_label.modulate = Color.WHITE
	message_label.show()

	message_tween = create_tween()
	message_tween.set_ignore_time_scale(true)
	message_tween.tween_interval(0.85)
	message_tween.tween_property(message_label, "modulate:a", 0.0, 0.35)
	message_tween.tween_callback(Callable(message_label, "hide"))

func reset_screen_motion() -> void:
	shake_time = 0.0
	shake = 0.0
	if is_instance_valid(background):
		background.position = Vector2.ZERO
	if is_instance_valid(world):
		world.position = Vector2.ZERO

func add_shake(strength: float, duration: float) -> void:
	shake = maxf(shake, strength)
	shake_time = maxf(shake_time, duration)

func update_screen_motion(delta: float) -> void:
	if not is_instance_valid(background) or not is_instance_valid(world):
		return

	if shake_time <= 0.0:
		background.position = Vector2.ZERO
		world.position = Vector2.ZERO
		return

	shake_time = maxf(shake_time - delta, 0.0)
	var x := random.randf_range(-shake, shake)
	var y := random.randf_range(-shake * SHAKE_Y_RATIO, shake * SHAKE_Y_RATIO)
	var offset := Vector2(x, y)
	world.position = offset
	background.position = offset * BACKGROUND_SHAKE_RATIO
	shake = lerpf(shake, 0.0, delta * SHAKE_FADE_SPEED)

func spawn_dust(position: Vector2, count: int, color: Color) -> void:
	if not is_instance_valid(dust_layer):
		return

	for i in range(count):
		var particle := Polygon2D.new()
		var size := random.randf_range(DUST_SIZE.x, DUST_SIZE.y)
		particle.polygon = PackedVector2Array([
			Vector2(-size, -size),
			Vector2(size, -size),
			Vector2(size, size),
			Vector2(-size, size),
		])
		particle.color = color
		particle.position = position + Vector2(
			random.randf_range(DUST_SPAWN_X.x, DUST_SPAWN_X.y),
			random.randf_range(DUST_SPAWN_Y.x, DUST_SPAWN_Y.y)
		)
		particle.z_index = DUST_Z_INDEX
		dust_layer.add_child(particle)

		var drift_x := random.randf_range(DUST_DRIFT_X.x, DUST_DRIFT_X.y)
		var drift_y := random.randf_range(DUST_DRIFT_Y.x, DUST_DRIFT_Y.y)
		var drift := Vector2(drift_x, drift_y)
		var duration := random.randf_range(DUST_LIFE.x, DUST_LIFE.y)
		var tween := create_tween()
		tween.tween_property(particle, "position", particle.position + drift, duration)
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(particle, "modulate:a", 0.0, DUST_FADE_TIME)
		tween.tween_callback(Callable(particle, "queue_free"))
