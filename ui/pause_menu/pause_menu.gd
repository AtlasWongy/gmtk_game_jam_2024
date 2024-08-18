extends PanelContainer
class_name PauseMenu

func _ready() -> void:
	SignalBus.set_pause_menu.connect(_on_set_pause_menu)
	
func _on_set_pause_menu(_pause_menu_state: bool):
	visible = _pause_menu_state