extends Node

@export var sensor_a: Area3D
@export var sensor_b: Area3D
@export var sensor_c: Area3D
@export var platform_4: MeshInstance3D
@export var platform_5: MeshInstance3D

var sensor_a_active: bool = false
var sensor_b_active: bool = false
var sensor_c_active: bool = false
var is_platform_4_moved: bool = false
var is_sensor_c_locked: bool = false
var tween: Tween

func _ready() -> void:
	sensor_a.body_entered.connect(activate_sensor_a)
	sensor_b.body_entered.connect(activate_sensor_b)
	sensor_c.body_entered.connect(activate_sensor_c)
	
	sensor_a.body_exited.connect(deactivate_sensor_a)
	sensor_b.body_exited.connect(deactivate_sensor_b)
	
func activate_sensor_a(_body: Node3D):
	sensor_a_active = true
	check_sensors()

func activate_sensor_b(_body: Node3D):
	sensor_b_active = true
	check_sensors()
	
func activate_sensor_c(_body: Node3D):
	sensor_c_active = true
	check_sensors()
	
func deactivate_sensor_a(_body: Node3D):
	sensor_a_active = false
	check_sensors()

func deactivate_sensor_b(_body: Node3D):
	sensor_b_active = false
	check_sensors()

func _on_platform_4_moved() -> void:
	if is_platform_4_moved:
		is_platform_4_moved = false
	elif !is_platform_4_moved:
		is_platform_4_moved = true
		
func lock_sensor_c() -> void:
	is_sensor_c_locked = true
	
func check_sensors() -> void:
	if sensor_a_active and sensor_b_active and !is_platform_4_moved:
		is_platform_4_moved = true
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(platform_4, "position:x", 2.0, 2.0).as_relative().from_current()
	elif (!sensor_a_active or !sensor_b_active) and is_platform_4_moved:
		is_platform_4_moved = false
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(platform_4, "position:x", -2.0, 2.0).as_relative().from_current()
	
	if sensor_c_active and !is_sensor_c_locked:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(platform_5, "global_rotation:z", 1.5708, 2.0).as_relative().from_current().finished.connect(lock_sensor_c)
