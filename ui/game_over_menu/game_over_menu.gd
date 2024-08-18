extends Node3D
class_name GameOverMenu

func _ready() -> void:
	SignalBus.set_game_over_menu.connect(_on_set_game_over_menu)
	
func _on_set_game_over_menu(_game_over_menu_state: bool) -> void:
	visible = true
