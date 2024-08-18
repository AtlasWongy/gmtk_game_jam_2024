extends AnimatableBody3D
@export var gate_dir:int = 10
@export var gate_height:int = 5

var open:bool = false

@onready var sensor = $Sensor
@onready var gate_mesh = $GateMesh

func _ready():
	if gate_height != 5:
		#adjust stuff here
		var offset = (gate_height - 5)

		global_position.y += offset/2
		gate_mesh.mesh.size.y += offset
		$CollisionShape3D.shape.size.y += offset
		sensor.position.y += offset/2




func _on_sensor_activate(body) -> void:
	if(!open and body is CharacterBody3D):
		print("detected!")
		print(global_position.y)
		print(gate_dir)
		print(global_position.y + gate_dir)
		#translate(Vector3i(0,10,0))
		var tween = get_tree().create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self,"global_position:y",global_position.y+gate_dir,1)
		open = true
