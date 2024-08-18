extends Node

enum CurrentBox {RED_BOX, BLUE_BOX}
enum GameState {NOT_STARTED, RUNNING, PAUSED, GAME_OVER_WIN, GAME_OVER_LOSE}

var current_box: CurrentBox
var game_state: GameState

var can_switch:bool = true

func _ready() -> void:
	SignalBus.set_current_box.connect(_disable_switch)
	SignalBus.set_enable_switch.connect(_enable_switch)
	SignalBus.set_game_state.connect(_on_set_game_state)
	
	current_box = CurrentBox.RED_BOX
	game_state = GameState.NOT_STARTED
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and game_state != GameState.NOT_STARTED:
		toggle_pause()

func _disable_switch():
	can_switch = false

func _enable_switch():
	can_switch = true

func _on_set_game_state(_game_state):
	game_state = _game_state
# 	if game_state == GameState.GAME_OVER_LOSE or game_state == GameState.GAME_OVER_WIN:
# 		toggle_game_over()
	
func toggle_pause() -> void:
	if get_tree().paused:
		get_tree().paused = false
		game_state = GameState.RUNNING
		SignalBus.set_pause_menu.emit(false)
	elif !get_tree().paused:
		get_tree().paused = true
		game_state = GameState.PAUSED
		SignalBus.set_pause_menu.emit(true)

# func toggle_game_over() -> void:
# 	if game_state == GameState.GAME_OVER_LOSE:
# 		SignalBus.set_game_over_menu(3)
# 	elif game_state == GameState.GAME_OVER_WIN:
# 		SignalBus.set_game_over_menu(4)


	
