extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):

		SignalBus.destroy_cube.emit(0)
		SignalBus.destroy_cube.emit(1)
		var timer = get_tree().create_timer(1)
		timer.timeout.connect(_respawn)
	
func _respawn():
	
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.RED_BOX, GameManager.level_id)
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.BLUE_BOX, GameManager.level_id)
	SignalBus.reset_level.emit()
