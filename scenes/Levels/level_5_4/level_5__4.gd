extends Node3D

@export var platform_5: MeshInstance3D
@export var platform_5_sensor: MeshInstance3D
@export var platform_4: MeshInstance3D
@export var reset_button: MeshInstance3D
@export var slope: Node3D

var is_platform_5_sensor_locked: bool = false
var platform_5_tween: Tween
var platform_4_tween: Tween
var is_reset_button_active: bool = false
var platform_5_can_reset: bool = false
var platform_4_can_reset: bool = false

func _ready() -> void:
	SignalBus.spawn_cube.connect(_toggle_reset_button)
	platform_5_sensor.sensor_activate.connect(_on_platform_5_sensor_activate)
	reset_button.sensor_activate.connect(_on_reset_level)
	
func _on_platform_5_sensor_activate(_body: Node3D, _parent: Node3D) -> void:
	if !is_platform_5_sensor_locked:
		is_platform_5_sensor_locked = true
		if platform_5_tween:
			platform_5_tween.kill()
		platform_5_tween = create_tween()
		platform_5_tween.tween_property(platform_5, "position:y", -11.3, 2.0).as_relative().from_current().finished.connect(_trigger_platform_4)
		await platform_5_tween.tween_property(platform_5, "position:x", -3.5, 2.0).as_relative().from_current().finished
		platform_5_can_reset = true
		
func _trigger_platform_4() -> void:
	if platform_4_tween:
		platform_4_tween.kill()
	platform_4_tween = create_tween()
	platform_4_tween.tween_property(platform_4, "position:y", 8.0, 2.0).as_relative().from_current()
	await platform_4_tween.tween_property(platform_4, "rotation:z", 1.5708, 2.0).as_relative().from_current().finished
	platform_4_can_reset = true
		
func _on_reset_level(_body: Node3D, _parent: Node3D) -> void:
	if is_reset_button_active:
		is_reset_button_active = false
		slope.boulder_count = 0
		
		if platform_5_can_reset:
			platform_5_can_reset = false
			if platform_5_tween:
				platform_5_tween.kill()
			platform_5_tween = create_tween()
			platform_5_tween.tween_property(platform_5, "position:y", 11.3, 2.0).as_relative().from_current()
			platform_5_tween.tween_property(platform_5, "position:x", 3.5, 2.0).as_relative().from_current().finished
			is_platform_5_sensor_locked = false
		
		if platform_4_can_reset:
			platform_4_can_reset = false
			if platform_4_tween:
				platform_4_tween.kill()
			platform_4_tween = create_tween()
			platform_4_tween.tween_property(platform_4, "position:y", -8.0, 2.0).as_relative().from_current()
			platform_4_tween.tween_property(platform_4, "rotation:z", -1.5708, 2.0).as_relative().from_current()
		
func _toggle_reset_button(_current_box: GameManager.CurrentBox, _level_ref: int) -> void:
	is_reset_button_active = true