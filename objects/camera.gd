extends Camera3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.get_camera.emit(self)
