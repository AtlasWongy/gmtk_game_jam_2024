extends Node

enum CurrentBox {RED_BOX, BLUE_BOX}
enum GameState {NOT_STARTED, RUNNING, PAUSED, GAME_OVER}

var current_box: CurrentBox
var game_state: GameState

var can_switch:bool = true

var level_ref: Node3D #used for spawners to spawn new cubes in
var camera_ref: Camera3D
var level_id:int = 3

func _ready() -> void:
	SignalBus.set_current_box.connect(_disable_switch)
	SignalBus.set_enable_switch.connect(_enable_switch)
	SignalBus.register_level.connect(_register_level)
	SignalBus.set_game_state.connect(_on_set_game_state)
	SignalBus.set_current_box.connect(_set_current_box)
	SignalBus.level_complete.connect(_level_complete)
	SignalBus.get_camera.connect(_set_camera)
	
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


	
