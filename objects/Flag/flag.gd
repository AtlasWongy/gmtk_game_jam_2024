extends Area3D

@onready var particles = $GPUParticles3D

func _on_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		SignalBus.level_complete.emit()
		particles.emitting = true
		var timer = get_tree().create_timer(1)
		timer.timeout.connect(_change_face)
		
		SignalBus.destroy_cube.emit(0)
		SignalBus.destroy_cube.emit(1)

func _change_face():
	if GameManager.level_id in [4]:
		return
	SignalBus.change_face.emit()
	var timer = get_tree().create_timer(1)
	timer.timeout.connect(_respawn)
	
func _respawn():
	SignalBus.respawn_sfx.emit()
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.RED_BOX, GameManager.level_id)
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.BLUE_BOX, GameManager.level_id)
