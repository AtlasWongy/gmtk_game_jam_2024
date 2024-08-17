extends AnimatableBody3D

var open:bool = false


func _on_sensor_activate(body) -> void:
	if(!open and body is CharacterBody3D):
		print("detected!")
		print(global_position)
		#translate(Vector3i(0,10,0))
		var tween = get_tree().create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self,"global_position",global_position+Vector3(0,10,0),1)
		open = true
	
	
