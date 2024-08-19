extends Node3D

@export var sensor_a: Area3D
@export var sensor_b: Area3D
@export var sensor_c: Area3D
@export var platform_4: MeshInstance3D
@export var platform_5: MeshInstance3D

var sensor_a_active: bool = false
var sensor_b_active: bool = false
var sensor_c_active: bool = false
var num_of_players_at_a: int = 0
var num_of_players_at_b: int = 0
var platform_4_points: Dictionary = {}
# var is_platform_4_moved: bool
var is_sensor_c_locked: bool = false
var tween: Tween

func _ready() -> void:
	sensor_a.body_entered.connect(activate_sensor_a)
	sensor_b.body_entered.connect(activate_sensor_b)
	sensor_c.body_entered.connect(activate_sensor_c)

	sensor_a.body_exited.connect(deactivate_sensor_a)
	sensor_b.body_exited.connect(deactivate_sensor_b)

# 	platform_4_points[0] = platform_4.global_position
# 	platform_4_points[1] = Vector3(platform_4.global_position.x + 2.0, platform_4.global_position.y, platform_4.global_position.z)
	platform_4_points[0] = platform_4.position
	platform_4_points[1] = Vector3(platform_4.position.x + 2.0, platform_4.position.y, platform_4.position.z)

func activate_sensor_a(_body: Node3D):
	num_of_players_at_a += 1
	if num_of_players_at_a == 1:
		sensor_a_active = true
	sensor_a_active = true
	check_sensors()

func activate_sensor_b(_body: Node3D):
	num_of_players_at_b += 1
	if num_of_players_at_b == 1:
		sensor_b_active = true
	check_sensors()

func activate_sensor_c(_body: Node3D):
	sensor_c_active = true
	check_sensors()

func deactivate_sensor_a(_body: Node3D):
	num_of_players_at_a -= 1
	if num_of_players_at_a == 0:
		sensor_a_active = false
	check_sensors()

func deactivate_sensor_b(_body: Node3D):
	num_of_players_at_b -= 1
	if num_of_players_at_b == 0:
		sensor_b_active = false
	check_sensors()

func lock_sensor_c() -> void:
	is_sensor_c_locked = true

func check_sensors() -> void:
	print("sensor a: ", sensor_a_active)
	print("sensor b: ", sensor_b_active)
# 	if sensor_a_active and sensor_b_active and platform_4.global_position == platform_4_points[0]:
	if sensor_a_active and sensor_b_active and platform_4.position == platform_4_points[0]:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(platform_4, "position:x", 2.0, 2.0).as_relative().from_current()
# 	elif (!sensor_a_active or !sensor_b_active) and platform_4.global_position == platform_4_points[1]:
	elif (!sensor_a_active or !sensor_b_active) and platform_4.position == platform_4_points[1]:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(platform_4, "position:x", -2.0, 2.0).as_relative().from_current()
	if sensor_c_active and !is_sensor_c_locked:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(platform_5, "global_rotation:z", 1.5708, 2.0).as_relative().from_current().finished.connect(lock_sensor_c)
