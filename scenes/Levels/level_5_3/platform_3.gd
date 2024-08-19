extends MeshInstance3D

@export var sensor: MeshInstance3D
var tween: Tween
var is_sensor_used: bool = false

func _ready() -> void:
	sensor.sensor_activate.connect(_on_sensor_activate)
	
func _on_sensor_activate(_body: Node3D, _parent: Node) -> void:
	if !is_sensor_used:
		is_sensor_used = true
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self, "global_position:y", 13.0, 2.0).as_relative().from_current()
