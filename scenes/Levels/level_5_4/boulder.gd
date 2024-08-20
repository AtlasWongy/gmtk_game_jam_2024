extends RigidBody3D
class_name Boulder

@onready var course_changer = get_node("../CourseChanger")

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1
	course_changer.body_entered.connect(_on_area_3d_body_entered)
	body_entered.connect(_on_body_entered)

func _on_area_3d_body_entered(_body: Node3D) -> void:
	var current_velocity = self.get_linear_velocity()
	var perpendicular_velocity = Vector3(-current_velocity.z, current_velocity.y, current_velocity.x)
	self.linear_velocity = perpendicular_velocity.normalized() * current_velocity.length()
	self.axis_lock_linear_z = true
	
func _on_body_entered(body: Node3D) -> void:
	if body is Player:
		body._destroy_cube(GameManager.CurrentBox.RED_BOX)
		body._destroy_cube(GameManager.CurrentBox.BLUE_BOX)
	
