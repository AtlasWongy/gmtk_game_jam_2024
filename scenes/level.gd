extends Node3D
#comment
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.register_level.emit(self)
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.RED_BOX, GameManager.level_id)
	SignalBus.spawn_cube.emit(GameManager.CurrentBox.BLUE_BOX, GameManager.level_id)
