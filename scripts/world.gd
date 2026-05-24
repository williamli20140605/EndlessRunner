extends Node2D

signal coin_collected(value: int, position: Vector2)
signal shield_collected(position: Vector2)
signal player_died
signal player_hurt
signal player_jumped(position: Vector2, first_jump: bool)
signal player_landed(position: Vector2)

const VIEWPORT_SIZE := Vector2(960, 640)
const FLOOR_TOP := 540.0
const GROUND_CENTER_Y := FLOOR_TOP + 20.0
const GROUND_SPACING := 180.0
const GROUND_POOL_SIZE := 9
const PLAYER_START_POSITION := Vector2(150.0, FLOOR_TOP)
const PLAYER_HIT_X_RANGE := 30.0
const SCROLLER_DESPAWN_X := -180.0
const LOW_COIN_VALUE := 1
const HIGH_COIN_VALUE := 2
const SHIELD_SPAWN_CHANCE := 0.06
const INTRO_DECORATION_X := [240.0, 470.0, 760.0, 1020.0]
const START_HAZARD_DISTANCE := 120.0
const START_DECOR_DISTANCE := 90.0
const SECTION_SPAWN_X := VIEWPORT_SIZE.x + 110.0
const DECOR_SPAWN_X := Vector2(40.0, 120.0)
const DECOR_GAP := Vector2(120.0, 330.0)
const NORMAL_GAP_START := Vector2(230.0, 360.0)
const NORMAL_GAP_END := Vector2(120.0, 220.0)
const RECOVERY_GAP_BONUS := Vector2(170.0, 220.0)
const RECENT_SECTION_COUNT := 4
const RECENT_SECTION_PENALTY := 0.22
const DIFFICULTY_TIME := 220.0
const SHIELD_DIFFICULTY_TIME := 240.0
const SHIELD_GAP_START := Vector2(1850.0, 2950.0)
const SHIELD_GAP_END := Vector2(1450.0, 2300.0)
const SHIELD_GAP_MIN := Vector2(1100.0, 1600.0)
const GROUND_COIN_Y := FLOOR_TOP - 28.0
const LOW_COIN_Y := FLOOR_TOP - 48.0
const MID_COIN_Y := FLOOR_TOP - 70.0
const GAP_COIN_Y := FLOOR_TOP - 74.0
const JUMP_COIN_Y := FLOOR_TOP - 78.0
const TALL_COIN_Y := FLOOR_TOP - 80.0
const HIGH_COIN_Y := FLOOR_TOP - 84.0
const LATE_COIN_Y := FLOOR_TOP - 86.0
const DUCK_BIRD_Y := FLOOR_TOP - 46.0
const HIGH_BIRD_Y := FLOOR_TOP - 112.0
const SHIELD_Y := FLOOR_TOP - 120.0
const CRATE_Y := FLOOR_TOP - 15.0
const BARREL_Y := FLOOR_TOP - 16.0
const SPIKES_Y := FLOOR_TOP - 10.0
const BIRD_RANDOM_X := Vector2(-10.0, 10.0)
const BIRD_SCALE := Vector2(0.98, 1.06)
const BIRD_BOB_AMOUNT := 5.5
const BIRD_BOB_SPEED := 4.0
const BONUS_COIN_SCALE := 1.08
const DECOR_SCALE := Vector2(0.78, 1.18)
const DECOR_Y := FLOOR_TOP - 16.0
const DECOR_Z_INDEX := -5
const HIT_FLOOR_Y := FLOOR_TOP - 16.0
const HIT_LOW_Y := FLOOR_TOP - 56.0
const LOW_HAZARD_Y := FLOOR_TOP - 34.0
const MID_HAZARD_Y := FLOOR_TOP - 72.0
const HIGH_HAZARD_PLAYER_Y := FLOOR_TOP - 70.0
const INTRO_COIN_START_X := 430.0
const INTRO_COIN_COUNT := 5
const INTRO_COIN_SPACING := 44.0
const REST_LENGTH := 240.0
const REST_COIN_X := -12.0
const REST_SHIELD_X := 80.0
const SINGLE_HOP_LENGTH := 290.0
const SINGLE_HOP_COIN_X := -82.0
const SINGLE_HOP_ARC_WIDTH := 182.0
const DUCK_GATE_LENGTH := 280.0
const DUCK_GATE_BIRD_X := 12.0
const DUCK_GATE_COIN_X := -74.0
const HOP_DUCK_LENGTH := 390.0
const HOP_DUCK_BIRD_X := 190.0
const HOP_DUCK_ARC_X := -72.0
const HOP_DUCK_LINE_X := 125.0
const DUCK_HOP_LENGTH := 400.0
const DUCK_HOP_BARREL_X := 210.0
const DUCK_HOP_LINE_X := -80.0
const DUCK_HOP_ARC_X := 118.0
const TWO_HOPS_LENGTH := 440.0
const TWO_HOPS_CRATE_X := -12.0
const TWO_HOPS_SPIKES_X := 190.0
const TWO_HOPS_FIRST_ARC_X := -86.0
const TWO_HOPS_SECOND_ARC_X := 100.0
const GAP_HOP_LENGTH := 470.0
const GAP_HOP_CUT_X := 42.0
const GAP_HOP_CRATE_X := 245.0
const GAP_HOP_FIRST_ARC_X := -50.0
const GAP_HOP_SECOND_ARC_X := 160.0
const SPLIT_LANE_LENGTH := 560.0
const SPLIT_LANE_BIRD_X := 210.0
const SPLIT_LANE_SPIKES_X := 360.0
const SPLIT_LANE_LINE_X := -110.0
const SPLIT_LANE_ARC_X := -28.0
const LATE_MIX_LENGTH := 650.0
const LATE_MIX_SPIKES_X := -10.0
const LATE_MIX_LOW_BIRD_X := 160.0
const LATE_MIX_BARREL_X := 320.0
const LATE_MIX_HIGH_BIRD_X := 492.0
const LATE_MIX_FIRST_ARC_X := -76.0
const LATE_MIX_LINE_X := 110.0
const LATE_MIX_SECOND_ARC_X := 238.0
const SMALL_COIN_LINE_COUNT := 3
const NORMAL_COIN_LINE_COUNT := 4
const SHORT_COIN_LINE_COUNT := 2
const SMALL_COIN_ARC_COUNT := 4
const BIG_COIN_ARC_COUNT := 5
const LONG_COIN_ARC_COUNT := 7
const GROUND_COIN_SPACING := 42.0
const WIDE_COIN_SPACING := 44.0
const NORMAL_COIN_SPACING := 46.0
const SHORT_ARC_WIDTH := 150.0
const NORMAL_ARC_WIDTH := 160.0
const MEDIUM_ARC_WIDTH := 165.0
const WIDE_ARC_WIDTH := 170.0
const GAP_ARC_WIDTH := 220.0
const SPLIT_ARC_WIDTH := 330.0
const LATE_ARC_WIDTH := 210.0
const LOW_ARC_HEIGHT := 54.0
const NORMAL_ARC_HEIGHT := 58.0
const HIGH_ARC_HEIGHT := 62.0
const GAP_ARC_HEIGHT := 78.0
const SPLIT_ARC_HEIGHT := 88.0
const LATE_FIRST_ARC_HEIGHT := 56.0
const LATE_ARC_HEIGHT := 70.0

const PLAYER_SCENE := preload("res://scenes/runner.tscn")
const GROUND_SCENE := preload("res://scenes/ground.tscn")
const CRATE_SCENE := preload("res://scenes/crate.tscn")
const BARREL_SCENE := preload("res://scenes/barrel.tscn")
const SPIKES_SCENE := preload("res://scenes/spikes.tscn")
const BIRD_SCENE := preload("res://scenes/bird.tscn")
const COIN_SCENE := preload("res://scenes/coin.tscn")
const SHIELD_SCENE := preload("res://scenes/shield_pickup.tscn")
const BUSH_TEXTURE := preload("res://assets/bush.svg")
const ROCK_TEXTURE := preload("res://assets/rock.svg")

var random: RandomNumberGenerator
var player
var ground_pool := []
var recent_sections := []
var next_hazard := 0.0
var next_decor := 0.0
var next_shield := 0.0
var recovery_sections := 0
var run_distance := 0.0
var run_time := 0.0
var has_shield := false

@onready var ground_layer: Node2D = $GroundSegments
@onready var scroll_layer: Node2D = $Scrollers
@onready var player_layer: Node2D = $RunnerSlot

func start_run(run_random: RandomNumberGenerator):
	random = run_random
	clear_run()
	recent_sections.clear()
	recovery_sections = 0
	next_hazard = START_HAZARD_DISTANCE
	_build_ground_pool()
	_seed_decorations()
	_seed_intro_coins()
	player = _spawn_player()
	_schedule_next_shield()
	_schedule_next_decor(START_DECOR_DISTANCE)
	return player

func clear_run() -> void:
	for child in ground_layer.get_children():
		child.queue_free()
	for child in scroll_layer.get_children():
		child.queue_free()
	for child in player_layer.get_children():
		child.queue_free()
	ground_pool.clear()
	player = null

func update_run(delta: float, speed: float, new_distance: float, new_time: float, shield_on: bool) -> void:
	run_distance = new_distance
	run_time = new_time
	has_shield = shield_on
	_scroll_world(delta, speed)
	_update_spawners()

func set_recovery_sections(value: int) -> void:
	recovery_sections = value

func _spawn_player():
	var new_player = PLAYER_SCENE.instantiate()
	new_player.position = PLAYER_START_POSITION
	new_player.died.connect(func(): player_died.emit())
	new_player.hurt.connect(func(): player_hurt.emit())
	new_player.jumped.connect(func(position: Vector2, first_jump: bool): player_jumped.emit(position, first_jump))
	new_player.landed.connect(func(position: Vector2): player_landed.emit(position))
	player_layer.add_child(new_player)
	return new_player

func _build_ground_pool() -> void:
	var ground_x := 0.0
	for i in range(GROUND_POOL_SIZE):
		var ground = GROUND_SCENE.instantiate()
		ground.position = Vector2(ground_x, GROUND_CENTER_Y)
		ground_layer.add_child(ground)
		ground.configure(true)
		ground_pool.append(ground)
		ground_x += GROUND_SPACING

func _scroll_world(delta: float, speed: float) -> void:
	for ground in ground_pool:
		if not is_instance_valid(ground) or ground.is_queued_for_deletion():
			continue
		ground.position.x -= speed * delta
		if ground.position.x < -GROUND_SPACING:
			_recycle_ground(ground)

	for node in get_tree().get_nodes_in_group("scrolling"):
		if not is_instance_valid(node) or node.is_queued_for_deletion():
			continue
		node.position.x -= speed * delta
		if node.is_in_group("hazard") and is_instance_valid(player):
			_check_hazard_contact(node)
		if node.position.x < SCROLLER_DESPAWN_X and node.name != "EasterEgg":
			node.queue_free()

func _check_hazard_contact(hazard: Node2D) -> void:
	if bool(hazard.get_meta("hit_registered", false)):
		return
	if not is_instance_valid(player) or not player.is_alive:
		return

	var gap := absf(hazard.position.x - player.position.x)
	if gap > PLAYER_HIT_X_RANGE:
		return

	var player_floor: bool = player.position.y > HIT_FLOOR_Y
	var player_low: bool = player.position.y > HIT_LOW_Y
	var hazard_y := hazard.position.y
	var hit := false
	if hazard_y > LOW_HAZARD_Y:
		hit = player_low
	elif hazard_y > MID_HAZARD_Y:
		hit = player_floor and not player.is_ducking
	else:
		hit = player.position.y < HIGH_HAZARD_PLAYER_Y

	if hit:
		hazard.set_meta("hit_registered", true)
		player.hit_hazard()

func _recycle_ground(ground: Node2D) -> void:
	ground.position.x = _get_farthest_ground_x() + GROUND_SPACING
	ground.position.y = GROUND_CENTER_Y
	ground.configure(true)

func _get_farthest_ground_x() -> float:
	var farthest := -INF
	for ground in ground_pool:
		if is_instance_valid(ground) and not ground.is_queued_for_deletion():
			farthest = max(farthest, ground.position.x)
	return farthest

func _update_spawners() -> void:
	if run_distance >= next_hazard:
		var section_length := _spawn_next_section()
		_schedule_next_hazard(section_length)

	if run_distance >= next_decor:
		var x := VIEWPORT_SIZE.x + random.randf_range(DECOR_SPAWN_X.x, DECOR_SPAWN_X.y)
		_spawn_decoration(x)
		_schedule_next_decor()

func _schedule_next_hazard(extra_dist := 0.0) -> void:
	var difficulty := clampf(run_time / DIFFICULTY_TIME, 0.0, 1.0)
	var min_gap := lerpf(NORMAL_GAP_START.x, NORMAL_GAP_END.x, difficulty)
	var max_gap := lerpf(NORMAL_GAP_START.y, NORMAL_GAP_END.y, difficulty)
	if recovery_sections > 0:
		min_gap += RECOVERY_GAP_BONUS.x
		max_gap += RECOVERY_GAP_BONUS.y
	next_hazard = run_distance + extra_dist + random.randf_range(min_gap, max_gap)

func _schedule_next_decor(extra_dist := 0.0) -> void:
	next_decor = run_distance + extra_dist + random.randf_range(DECOR_GAP.x, DECOR_GAP.y)

func _spawn_next_section() -> float:
	var spawn_x := SECTION_SPAWN_X
	var section_name := _choose_section()
	recent_sections.append(section_name)
	if recent_sections.size() > RECENT_SECTION_COUNT:
		recent_sections.pop_front()

	match section_name:
		"rest":
			return _section_rest(spawn_x)
		"single_hop":
			return _section_single_hop(spawn_x)
		"duck_gate":
			return _section_duck_gate(spawn_x)
		"hop_duck":
			return _section_hop_duck(spawn_x)
		"duck_hop":
			return _section_duck_hop(spawn_x)
		"two_hops":
			return _section_two_hops(spawn_x)
		"gap_hop":
			return _section_gap_hop(spawn_x)
		"split_lane":
			return _section_split_lane(spawn_x)
		"late_mix":
			return _section_late_mix(spawn_x)
	return _section_single_hop(spawn_x)

func _choose_section() -> String:
	if recovery_sections > 0:
		recovery_sections -= 1
		return "rest"

	var choices := _get_section_choices()
	var total_weight := 0.0
	for choice in choices:
		total_weight += _section_weight(choice)

	var roll := random.randf_range(0.0, total_weight)
	for choice in choices:
		roll -= _section_weight(choice)
		if roll <= 0.0:
			return String(choice[0])
	return "single_hop"

func _get_section_choices() -> Array:
	var choices := [
		["single_hop", 3.2],
		["duck_gate", 2.8],
		["hop_duck", 2.4],
		["duck_hop", 2.2],
		["rest", 1.0],
	]
	if run_time > 24.0:
		choices.append(["two_hops", 2.2])
		choices.append(["gap_hop", 1.7])
	if run_time > 48.0:
		choices.append(["split_lane", 2.0])
	if run_time > 78.0:
		choices.append(["late_mix", 1.5])
	return choices

func _section_weight(choice: Array) -> float:
	var name := String(choice[0])
	var weight := float(choice[1])
	if recent_sections.has(name):
		weight *= RECENT_SECTION_PENALTY
	return weight

func _section_rest(x: float) -> float:
	_spawn_coin_line(x + REST_COIN_X, MID_COIN_Y, NORMAL_COIN_LINE_COUNT, NORMAL_COIN_SPACING, LOW_COIN_VALUE)
	if random.randf() < SHIELD_SPAWN_CHANCE:
		_maybe_spawn_shield(Vector2(x + REST_SHIELD_X, SHIELD_Y))
	return REST_LENGTH

func _section_single_hop(x: float) -> float:
	_spawn_floor_hazard_at(x, "crate")
	_spawn_coin_arc(x + SINGLE_HOP_COIN_X, SINGLE_HOP_ARC_WIDTH, JUMP_COIN_Y, NORMAL_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	return SINGLE_HOP_LENGTH

func _section_duck_gate(x: float) -> float:
	_spawn_bird_at(x + DUCK_GATE_BIRD_X, DUCK_BIRD_Y, true)
	_spawn_coin_line(x + DUCK_GATE_COIN_X, GROUND_COIN_Y, NORMAL_COIN_LINE_COUNT, GROUND_COIN_SPACING, LOW_COIN_VALUE)
	return DUCK_GATE_LENGTH

func _section_hop_duck(x: float) -> float:
	_spawn_floor_hazard_at(x, "spikes")
	_spawn_bird_at(x + HOP_DUCK_BIRD_X, DUCK_BIRD_Y, true)
	_spawn_coin_arc(x + HOP_DUCK_ARC_X, NORMAL_ARC_WIDTH, JUMP_COIN_Y, LOW_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	_spawn_coin_line(x + HOP_DUCK_LINE_X, GROUND_COIN_Y, SMALL_COIN_LINE_COUNT, GROUND_COIN_SPACING, LOW_COIN_VALUE)
	return HOP_DUCK_LENGTH

func _section_duck_hop(x: float) -> float:
	_spawn_bird_at(x, DUCK_BIRD_Y, true)
	_spawn_floor_hazard_at(x + DUCK_HOP_BARREL_X, "barrel")
	_spawn_coin_line(x + DUCK_HOP_LINE_X, GROUND_COIN_Y, NORMAL_COIN_LINE_COUNT, GROUND_COIN_SPACING, LOW_COIN_VALUE)
	_spawn_coin_arc(x + DUCK_HOP_ARC_X, NORMAL_ARC_WIDTH, TALL_COIN_Y, NORMAL_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	return DUCK_HOP_LENGTH

func _section_two_hops(x: float) -> float:
	_spawn_floor_hazard_at(x + TWO_HOPS_CRATE_X, "crate")
	_spawn_floor_hazard_at(x + TWO_HOPS_SPIKES_X, "spikes")
	_spawn_coin_arc(x + TWO_HOPS_FIRST_ARC_X, WIDE_ARC_WIDTH, JUMP_COIN_Y, LOW_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	_spawn_coin_arc(x + TWO_HOPS_SECOND_ARC_X, WIDE_ARC_WIDTH, HIGH_COIN_Y, HIGH_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	return TWO_HOPS_LENGTH

func _section_gap_hop(x: float) -> float:
	_cut_ground_at(x + GAP_HOP_CUT_X)
	_spawn_floor_hazard_at(x + GAP_HOP_CRATE_X, "crate")
	_spawn_coin_arc(x + GAP_HOP_FIRST_ARC_X, GAP_ARC_WIDTH, GAP_COIN_Y, GAP_ARC_HEIGHT, BIG_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	_spawn_coin_arc(x + GAP_HOP_SECOND_ARC_X, SHORT_ARC_WIDTH, JUMP_COIN_Y, NORMAL_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	return GAP_HOP_LENGTH

func _section_split_lane(x: float) -> float:
	_spawn_floor_hazard_at(x, "barrel")
	_spawn_bird_at(x + SPLIT_LANE_BIRD_X, HIGH_BIRD_Y, false)
	_spawn_floor_hazard_at(x + SPLIT_LANE_SPIKES_X, "spikes")
	_spawn_coin_line(x + SPLIT_LANE_LINE_X, LOW_COIN_Y, SHORT_COIN_LINE_COUNT, WIDE_COIN_SPACING, LOW_COIN_VALUE)
	_spawn_coin_arc(x + SPLIT_LANE_ARC_X, SPLIT_ARC_WIDTH, HIGH_COIN_Y, SPLIT_ARC_HEIGHT, LONG_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	return SPLIT_LANE_LENGTH

func _section_late_mix(x: float) -> float:
	_spawn_floor_hazard_at(x + LATE_MIX_SPIKES_X, "spikes")
	_spawn_bird_at(x + LATE_MIX_LOW_BIRD_X, DUCK_BIRD_Y, true)
	_spawn_floor_hazard_at(x + LATE_MIX_BARREL_X, "barrel")
	_spawn_bird_at(x + LATE_MIX_HIGH_BIRD_X, HIGH_BIRD_Y, false)
	_spawn_coin_arc(x + LATE_MIX_FIRST_ARC_X, MEDIUM_ARC_WIDTH, TALL_COIN_Y, LATE_FIRST_ARC_HEIGHT, SMALL_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	_spawn_coin_line(x + LATE_MIX_LINE_X, GROUND_COIN_Y, SMALL_COIN_LINE_COUNT, GROUND_COIN_SPACING, LOW_COIN_VALUE)
	_spawn_coin_arc(x + LATE_MIX_SECOND_ARC_X, LATE_ARC_WIDTH, LATE_COIN_Y, LATE_ARC_HEIGHT, BIG_COIN_ARC_COUNT, HIGH_COIN_VALUE)
	return LATE_MIX_LENGTH

func _spawn_floor_hazard_at(x: float, kind: String) -> bool:
	if not _has_solid_ground_at(x):
		return false

	var hazard_scene: PackedScene = CRATE_SCENE
	var y := CRATE_Y
	if kind == "barrel":
		hazard_scene = BARREL_SCENE
		y = BARREL_Y
	elif kind == "spikes":
		hazard_scene = SPIKES_SCENE
		y = SPIKES_Y

	var hazard := hazard_scene.instantiate() as Area2D
	hazard.position = Vector2(x, y)
	hazard.scale = Vector2.ONE
	scroll_layer.add_child(hazard)
	return true

func _spawn_bird_at(x: float, y: float, needs_ground: bool) -> bool:
	if needs_ground and not _has_solid_ground_at(x):
		return false

	var bird = BIRD_SCENE.instantiate()
	bird.position = Vector2(x + random.randf_range(BIRD_RANDOM_X.x, BIRD_RANDOM_X.y), y)
	bird.scale = Vector2.ONE * random.randf_range(BIRD_SCALE.x, BIRD_SCALE.y)
	bird.set_vertical_motion(BIRD_BOB_AMOUNT, BIRD_BOB_SPEED)
	scroll_layer.add_child(bird)
	return true

func _cut_ground_at(x_pos: float) -> void:
	for ground in ground_pool:
		if not is_instance_valid(ground) or ground.is_queued_for_deletion():
			continue
		if ground.contains_x(x_pos):
			ground.configure(false)
			return

func _spawn_coin_line(start_x: float, y: float, count: int, spacing: float, value: int) -> void:
	for i in range(count):
		_spawn_coin(Vector2(start_x + i * spacing, y), value)

func _spawn_coin_arc(start_x: float, width: float, center_y: float, height: float, count: int, value: int) -> void:
	for i in range(count):
		var progress := _get_arc_progress(i, count)
		var x := start_x + progress * width
		var y := center_y - sin(progress * PI) * height
		_spawn_coin(Vector2(x, y), value)

func _get_arc_progress(index: int, count: int) -> float:
	if count <= 1:
		return 0.0
	return float(index) / float(count - 1)

func _spawn_coin(position: Vector2, value: int) -> void:
	var coin = COIN_SCENE.instantiate()
	coin.position = position
	coin.value = value
	if value > LOW_COIN_VALUE:
		coin.scale *= BONUS_COIN_SCALE
	coin.collected.connect(func(value: int, position: Vector2): coin_collected.emit(value, position))
	scroll_layer.add_child(coin)

func _maybe_spawn_shield(position: Vector2) -> void:
	if has_shield:
		return
	if run_distance < next_shield:
		return
	if random.randf() > SHIELD_SPAWN_CHANCE:
		return

	var pickup = SHIELD_SCENE.instantiate()
	pickup.position = position
	pickup.collected.connect(func(position: Vector2): shield_collected.emit(position))
	scroll_layer.add_child(pickup)
	_schedule_next_shield()

func _schedule_next_shield() -> void:
	var difficulty := clampf(run_time / SHIELD_DIFFICULTY_TIME, 0.0, 1.0)
	var min_gap := maxf(SHIELD_GAP_MIN.x, lerpf(SHIELD_GAP_START.x, SHIELD_GAP_END.x, difficulty))
	var max_gap := maxf(SHIELD_GAP_MIN.y, lerpf(SHIELD_GAP_START.y, SHIELD_GAP_END.y, difficulty))
	next_shield = run_distance + random.randf_range(min_gap, max_gap)

func _has_solid_ground_at(x_pos: float) -> bool:
	for ground in ground_pool:
		if not is_instance_valid(ground) or ground.is_queued_for_deletion():
			continue
		if ground.contains_x(x_pos):
			return ground.is_solid
	return true

func _seed_decorations() -> void:
	for x in INTRO_DECORATION_X:
		_spawn_decoration(float(x))

func _seed_intro_coins() -> void:
	_spawn_coin_line(INTRO_COIN_START_X, MID_COIN_Y, INTRO_COIN_COUNT, INTRO_COIN_SPACING, LOW_COIN_VALUE)

func _spawn_decoration(x: float) -> void:
	var decoration := Sprite2D.new()
	if random.randf() < 0.68:
		decoration.texture = BUSH_TEXTURE
	else:
		decoration.texture = ROCK_TEXTURE
	decoration.position = Vector2(x, DECOR_Y)
	decoration.scale = Vector2.ONE * random.randf_range(DECOR_SCALE.x, DECOR_SCALE.y)
	decoration.flip_h = random.randf() < 0.5
	decoration.z_index = DECOR_Z_INDEX
	decoration.add_to_group("scrolling")
	scroll_layer.add_child(decoration)
