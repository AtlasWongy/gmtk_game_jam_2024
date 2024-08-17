extends Area3D

signal change_face()

func _on_body_entered(body: Node3D) -> void:
	if(body is CharacterBody3D):
		print(body)
		var timer = get_tree().create_timer(1)
		timer.timeout.connect(_change_face)

func _change_face():
	change_face.emit()
