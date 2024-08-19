extends AnimatableBody3D
@export var x_size:int = 10
@export var x_offset:int = 7

var extend:bool = false
var shrink:bool = false

@onready var sensor = $Sensor
@onready var extenderMesh = $ExtenderMesh
@onready var collisionShape = $CollisionShape3D

var extender_id

func _ready():
	extender_id = "Extender_%d" % get_instance_id()
	print(extender_id)
	print("Ready Extender: ", extender_id)
	#sensor.connect(self, "_on_sensor_activate", [self])
	#sensor.connect(self, "_on_sensor_deactivate", [self])
	
	
func _on_sensor_activate(body, extender_instance) -> void:
	print("detected extender activate!")
	print(extender_instance)
	if(!extend and "Extender_%d" % get_instance_id() == "Extender_%d" % extender_instance.get_instance_id()): # and body is CharacterBody3D
		var tween = extender_instance.create_tween()
		print(extender_instance)
		tween.set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(extender_instance.get_node("ExtenderMesh"), "position", Vector3(x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(extender_instance.get_node("CollisionShape3D"), "position", Vector3(x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(extender_instance.get_node("ExtenderMesh").mesh, "size", Vector3(x_size, 0, 0), 1).as_relative().from_current()
		tween.tween_property(extender_instance.get_node("CollisionShape3D").shape, "size", Vector3(x_size, 0, 0), 1).as_relative().from_current()
		extend = true
		shrink = false

func _on_sensor_deactivate(body, extender_instance) -> void:
	if(!shrink): #  and body is CharacterBody3D
		print("detected extender deactivate!")
		var tween = extender_instance.create_tween()
		tween.set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(extenderMesh, "position", Vector3(-x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(7, 0, 0), 1).as_relative().from_current()
		tween.tween_property(extenderMesh.mesh, "size", Vector3(-x_size, 0, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape.shape, "size", Vector3(-x_size, 0, 0), 1).as_relative().from_current()
		shrink = true
		extend = false
