extends MeshInstance3D

signal sensor_activate

func _on_area_3d_body_entered(body: Node3D) -> void:
	sensor_activate.emit(body, get_parent())


func _on_area_3d_body_exited(body):
	sensor_deactivate.emit(body, get_parent())
