extends MeshInstance3D

signal sensor_activate
signal sensor_deactivate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	sensor_activate.emit(body, get_parent())


func _on_area_3d_body_exited(body):
	sensor_deactivate.emit(body, get_parent())
