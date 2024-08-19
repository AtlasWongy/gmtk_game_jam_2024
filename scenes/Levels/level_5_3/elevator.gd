extends MeshInstance3D
class_name Elevator

@export var elevator_switch: Area3D
var tween: Tween

func _ready() -> void:
	elevator_switch.body_entered.connect(activate_lift)
	
func activate_lift(_body: Node3D) -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "global_position:y", 20.0, 5.0).as_relative().from_current()
