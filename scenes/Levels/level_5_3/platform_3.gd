extends MeshInstance3D

@export var sensor: MeshInstance3D
@export var platform_timer: Timer
var tween: Tween
var is_sensor_used: bool = false

func _ready() -> void:
	sensor.sensor_activate.connect(_on_sensor_activate)
	platform_timer.timeout.connect(_on_reset_platform)
	
func _on_sensor_activate(_body: Node3D, _parent: Node) -> void:
	if !is_sensor_used:
		is_sensor_used = true
		if tween:
			tween.kill()
		tween = create_tween()
		await tween.tween_property(self, "global_position:y", 13.0, 2.0).as_relative().from_current().finished
		platform_timer.start()
		
func _on_reset_platform() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	await tween.tween_property(self, "global_position:y", -13.0, 2.0).as_relative().from_current().finished
	is_sensor_used = false