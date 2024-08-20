extends Node3D

@export var sensor: MeshInstance3D
@export var boulder_scene: PackedScene
var boulder_count: int = 0

func _ready() -> void:
	sensor.sensor_activate.connect(_on_sensor_activate)
	
func _on_sensor_activate(_body: Node3D, _parent: Node3D) -> void:
	boulder_count += 1
	if boulder_count == 1:
		var boulder = boulder_scene.instantiate()
		add_child(boulder)
		boulder.position = Vector3(-0.5, 6.2, -2.0)
