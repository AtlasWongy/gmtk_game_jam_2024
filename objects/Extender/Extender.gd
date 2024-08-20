extends AnimatableBody3D
@export var x_size:int = 10
@export var x_offset:int = 7

var extend:bool = false
var shrink:bool = false

var level_completed: bool = false

@onready var sensor = $Sensor
@onready var extenderMesh = $ExtenderMesh
@onready var collisionShape = $CollisionShape3D

var item_placed

func _ready():
	pass
	#sensor.connect(self, "_on_sensor_activate", [self])
	#sensor.connect(self, "_on_sensor_deactivate", [self])
	
	
func _on_sensor_activate(body) -> void:
	print("detected extender activate!")
	if(!extend and !item_placed): # and body is CharacterBody3D
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(extenderMesh, "position", Vector3(x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(extenderMesh.mesh, "size", Vector3(x_size, 0, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape.shape, "size", Vector3(x_size, 0, 0), 1).as_relative().from_current()
		extend = true
		shrink = false
		
		if (body is RigidBody3D):
			item_placed = true
		else:
			item_placed = false

func _on_sensor_deactivate(body) -> void:
	if (body is RigidBody3D):
		item_placed = false
	if(!shrink and !item_placed and !level_completed): #  and body is CharacterBody3D
		print("detected extender deactivate!")
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(extenderMesh, "position", Vector3(-x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(-x_offset, 0, 0), 1).as_relative().from_current()
		tween.tween_property(extenderMesh.mesh, "size", Vector3(-x_size, 0, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape.shape, "size", Vector3(-x_size, 0, 0), 1).as_relative().from_current()
		shrink = true
		extend = false
	
