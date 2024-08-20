extends AnimatableBody3D
@export var up_gate_dir:int = 10
@export var down_gate_dir:int = 10
@export var gate_height:int = 5

var open:bool = false
var count: int = 0

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
	if(!open and body is CharacterBody3D and count == 0):
		count += 1
		print("detected!")
		print(global_position.y)
		print(up_gate_dir)
		print(global_position.y + up_gate_dir)
		#translate(Vector3i(0,10,0))
		var tween = get_tree().create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		
		tween.set_parallel(true)
		tween.tween_property(self,"global_position:y",global_position.y-down_gate_dir,1)
		tween.tween_property(remote_transform,"global_position:y",global_position.y-down_gate_dir,1)
		
		await create_tween().tween_interval(4).finished

		var tween2 = get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(self,"global_position:y",global_position.y+up_gate_dir,1)
		tween2.tween_property(remote_transform,"global_position:y",global_position.y+up_gate_dir,1)

		open = true
