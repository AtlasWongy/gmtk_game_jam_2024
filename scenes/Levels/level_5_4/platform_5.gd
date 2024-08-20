extends MeshInstance3D

signal _shift_platform_4()

@export var sensor: MeshInstance3D
var tween: Tween
var sensor_locked: bool = false

func _ready() -> void:
	sensor.sensor_activate.connect(_on_sensor_activate)
	
func _on_sensor_activate(_body: Node3D, _parent: Node3D) -> void:
	if !sensor_locked:
		sensor_locked = true
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "position:y", -11.3, 2.0).as_relative().from_current().finished.connect(_on_shift_platform_4)
		tween.tween_property(self, "position:x", -3.5, 2.0).as_relative().from_current()

func _on_shift_platform_4() -> void:
	_shift_platform_4.emit()