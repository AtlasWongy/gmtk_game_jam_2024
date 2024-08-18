extends PanelContainer
class_name GameOverMenu

@export var retry_button: Button
@export var completion_time_label: Label

func _ready() -> void:
	SignalBus.set_game_over_menu.connect(_on_set_game_over_menu)
	SignalBus.send_completion_time.connect(_on_set_completion_time)
	retry_button.button_down.connect(restart_game)
	
func restart_game() -> void:
	print("Restart Game")

func _on_set_game_over_menu(_game_over_menu_state: bool) -> void:
	visible = true

func _on_set_completion_time(_completion_time: String):
	completion_time_label.text = _completion_time
