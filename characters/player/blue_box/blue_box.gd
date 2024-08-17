extends Player
class_name BlueBox

@export var mesh: MeshInstance3D
@export var collision_shape: CollisionShape3D

var can_trigger: bool = true
var trigger_growth: bool
var trigger_shrink: bool
var tween: Tween

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("grow") and can_trigger:
		trigger_growth = true
	elif event.is_action_pressed("shrink") and can_trigger:
		trigger_shrink = true
	else:
		trigger_growth = false
		trigger_shrink = false
		
func _physics_process(_delta: float) -> void:
	if trigger_growth and check_can_grow():
		can_trigger = false

		if tween:
			tween.kill()
		tween = create_tween()
		tween.set_parallel()

		tween.tween_property(mesh.mesh, "size:x", 5, 1).as_relative().from_current().finished.connect(reset_trigger)
		tween.tween_property(collision_shape.shape, "size:x", 5, 1).as_relative().from_current()
	elif trigger_shrink and check_can_shrink():
		can_trigger = false

		if tween:
			tween.kill()
		tween = create_tween()
		tween.set_parallel()

		tween.tween_property(mesh.mesh, "size:x", -5, 1).as_relative().from_current().finished.connect(reset_trigger)
		tween.tween_property(collision_shape.shape, "size:x", -5, 1).as_relative().from_current()
		
func check_can_grow() -> bool:
	if mesh.mesh.size.x <= 10.0:
		return true
	else:
		return false
	
func check_can_shrink() -> bool:
	if mesh.mesh.size.x == 1.0:
		return false
	else:
		return true

func reset_trigger() -> void:
	can_trigger = true
