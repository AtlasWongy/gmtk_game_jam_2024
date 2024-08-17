extends PanelContainer
class_name MainMenu

@export var start_button: Button

var tween: Tween

func _ready() -> void:
	start_button.button_down.connect(_on_start_game)
	
func _on_start_game() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	
	tween.tween_property(self, "global_position:y", -600, 1)
	SignalBus.set_game_state.emit(GameManager.GameState.RUNNING)
