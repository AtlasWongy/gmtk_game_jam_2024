extends Node3D

@export var gate: RemoteTransform3D

func _ready() -> void:
	SignalBus.level_complete.connect(_on_level_complete)

func _on_level_complete() -> void:
	if GameManager.level_id == 3:
		gate.queue_free()
