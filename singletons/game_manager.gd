extends Node

enum CurrentBox {RED_BOX, BLUE_BOX}
enum GameState {NOT_STARTED, RUNNING, PAUSED, GAME_OVER}

# var game_scenes = {
# 	0: "res://scenes/Game.tscn",
# 	1: "res://scenes/Game2.tscn"
# }

var cube_levels = {
	1: "res://scenes/Cubes/cube_level_2.tscn"
}

var current_scene = null
var root = null
var current_box: CurrentBox
var game_state: GameState
var can_switch:bool = true

var level_ref: Node3D #used for spawners to spawn new cubes in\
var game_ref: Node #used for audio controller to spawn children
var camera_ref: Camera3D
var level_id:int = 0

func _ready() -> void:
	SignalBus.set_current_box.connect(_disable_switch)
	SignalBus.set_enable_switch.connect(_enable_switch)
	SignalBus.register_level.connect(_register_level)
	SignalBus.set_game_state.connect(_on_set_game_state)
	SignalBus.set_current_box.connect(_set_current_box)
	SignalBus.level_complete.connect(_level_complete)
	SignalBus.get_camera.connect(_set_camera)
	SignalBus.transition_next_level.connect(_switch_cube_level)
	
	root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)
	
	current_box = CurrentBox.RED_BOX
	game_state = GameState.NOT_STARTED
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and game_state != GameState.NOT_STARTED:
		toggle_pause()

func _set_current_box():
	if current_box == CurrentBox.RED_BOX:
		current_box = CurrentBox.BLUE_BOX
	else:
		current_box = CurrentBox.RED_BOX

func _level_complete():
	level_id += 1
	if level_id in [4]:
# 		SignalBus.set_game_over_menu.emit(true)
		_on_set_game_state(GameManager.GameState.GAME_OVER)

func _set_camera(cam:Camera3D):
	camera_ref = cam

func _disable_switch():
	can_switch = false

func _enable_switch():
	can_switch = true
	
func _register_level(level:Node3D):
	level_ref = level

func _on_set_game_state(_game_state):
	game_state = _game_state
	if game_state == GameManager.GameState.GAME_OVER:
		toggle_game_over()
	
func toggle_pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
		game_state = GameState.RUNNING
		SignalBus.set_pause_menu.emit(false)
	elif !get_tree().paused:
		get_tree().paused = true
		game_state = GameState.PAUSED
		SignalBus.set_pause_menu.emit(true)

func toggle_game_over() -> void:
	SignalBus.set_game_over_menu.emit(true)
	get_tree().paused = false
	
func _switch_cube_level() -> void:
	# Reset Level Id
	level_id = 0
	
	# Close Game Over Menu
	# Game State back to NOT_STARTED
	_on_set_game_state(GameManager.GameState.NOT_STARTED)
	SignalBus.set_game_over_menu.emit(false)
	
	# Reset Timer
	SignalBus.reset_timer_ui.emit()
	call_deferred("_deferred_switch_cube_level", cube_levels[1])
	
func _deferred_switch_cube_level(_res_path) -> void:
	var cube_level = current_scene.get_child(0).get_child(3)
	var tween: Tween = create_tween()
	await tween.tween_property(cube_level, "global_position:y", -100.0, 1.0).as_relative().from_current().set_trans(Tween.TRANS_SPRING).finished
	
	cube_level.free()
	var next_cube_level = load(_res_path)
	cube_level = next_cube_level.instantiate()
	current_scene.get_child(0).add_child(cube_level)
	cube_level.global_position = Vector3(0, 100.0, 0)

	if tween:
		tween.kill()
	tween = create_tween()
	await tween.tween_property(cube_level, "global_position:y", -100, 1.0).as_relative().from_current().as_relative().from_current().set_trans(Tween.TRANS_SPRING).finished
	
	# Spawn Players
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.RED_BOX, GameManager.level_id)
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.BLUE_BOX, GameManager.level_id)
	
	_on_set_game_state(GameManager.GameState.RUNNING)
	
# For my Reference (Yi Jie) will remove later towards the end	
# 	current_scene.free()
# 	var next_scene = load(_res_path)
# 	current_scene = next_scene.instantiate()
# 	get_tree().root.add_child(current_scene)
# 	get_tree().current_scene = current_scene


	
