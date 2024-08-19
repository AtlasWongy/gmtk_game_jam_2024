extends MeshInstance3D
class_name ToxicBall

@export var toxic_area: Area3D

func _ready() -> void:
	toxic_area.body_entered.connect(poison_player)
	
func poison_player(body: Node3D):
	if body is Player:
		body.is_poison = true
		queue_free()
