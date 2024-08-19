extends Node
class_name CureBall

@export var cure_area: Area3D

func _ready() -> void:
	cure_area.body_entered.connect(cure_player)
	
func cure_player(body: Node3D):
	if body is Player:
		body.is_poison = false
		queue_free()
