extends AnimatableBody3D
@export var gate_dir:int = 10
@export var gate_height:int = 5

var open:bool = false

@onready var sensor = $Sensor
@onready var gate_mesh = $GateMesh

var remote_transform:RemoteTransform3D

func _ready():
	if gate_height != 5:
		print("adjusting gate height")
		#adjust stuff here
		var offset = (gate_height - 5)

		global_position.y += offset/2
		gate_mesh.mesh.size.y += offset
		$CollisionShape3D.shape.size.y += offset
		sensor.position.y += offset/2
		remote_transform = get_parent().find_child("GateRemoteTransform3D")
		remote_transform.global_position = global_position
		
		
func _on_sensor_activate(body) -> void:
	if(!open and body is CharacterBody3D):
		SignalBus.interactable_sfx.emit()

		var tween = get_tree().create_tween().set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self,"global_position:y",global_position.y+gate_dir,1)
		tween.tween_property(remote_transform,"global_position:y",global_position.y+gate_dir,1)

		open = true
