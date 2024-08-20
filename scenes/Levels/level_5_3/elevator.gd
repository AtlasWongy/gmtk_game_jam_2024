extends MeshInstance3D
class_name Elevator

@export var elevator_switch: Area3D
@export var elevator_timer: Timer
var tween: Tween
var is_moving: bool = false

func _ready() -> void:
	elevator_switch.body_entered.connect(activate_lift)
	elevator_timer.timeout.connect(reset_lift_and_lift_switch)
	
func activate_lift(_body: Node3D) -> void:
	if !is_moving:
		is_moving = true
		if tween:
			tween.kill()
		tween = create_tween()
		await tween.tween_property(self, "global_position:y", 20.0, 5.0).as_relative().from_current().finished
		elevator_timer.start()
	
func reset_lift_and_lift_switch() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	await tween.tween_property(self, "global_position:y", -20.0, 5.0).as_relative().from_current().finished
	is_moving = false
