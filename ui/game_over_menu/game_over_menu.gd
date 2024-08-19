extends PanelContainer
class_name GameOverMenu

@export var retry_button: Button
@export var completion_time_label: Label

var is_game_over_menu_visible: bool = false

func _ready() -> void:
	# SignalBus.set_game_over_menu.connect(_on_set_game_over_menu)
	SignalBus.send_completion_time.connect(_on_set_completion_time)
	retry_button.button_down.connect(transition_next_level)
	
func transition_next_level() -> void:
	SignalBus.transition_next_level.emit()

func _on_set_game_over_menu() -> void:
	# _game_over_menu_state: bool
	is_game_over_menu_visible = !is_game_over_menu_visible
	visible = is_game_over_menu_visible

func _on_set_completion_time(_completion_time: String):
	completion_time_label.text = _completion_time
