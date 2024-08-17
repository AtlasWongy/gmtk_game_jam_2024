extends Node3D
class_name GameStarter

func _ready() -> void:
	get_tree().paused = true

func _process(_delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.RUNNING:
		get_tree().paused = false
		queue_free()
