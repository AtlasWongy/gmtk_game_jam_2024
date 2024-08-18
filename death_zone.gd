extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		# body.queue_free()
		print("Character Died")
		SignalBus.set_game_state.emit(GameManager.GameState.GAME_OVER_LOSE)