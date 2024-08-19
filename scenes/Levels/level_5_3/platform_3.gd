extends MeshInstance3D

@export var sensor: MeshInstance3D
var tween: Tween

func _ready() -> void:
	sensor.sensor_activate.connect(_on_sensor_activate)
	
func _on_sensor_activate(_body: Node3D, _parent: Node) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position:y", 8.2, 2.0).as_relative().from_current()
