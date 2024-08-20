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

var orignal_mesh_position
var original_collision_position

var count = 0
var current_body

func _ready():
	orignal_mesh_position = extenderMesh.get_position()
	original_collision_position = collisionShape.get_position()
	#sensor.connect(self, "_on_sensor_activate", [self])
	#sensor.connect(self, "_on_sensor_deactivate", [self])
	
	
func _on_sensor_activate(body) -> void:
	print("detected extender activate!")
	SignalBus.interactable_sfx.emit()
	if(!extend and !item_placed): # and body is CharacterBody3D
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(extenderMesh, "position", Vector3(orignal_mesh_position.x + x_offset, 0, 0), 1)
		tween.tween_property(collisionShape, "position", Vector3(original_collision_position.x + x_offset, 0, 0), 1)
		tween.tween_property(extenderMesh.mesh, "size", Vector3(x_size, 1, 5), 1)
		tween.tween_property(collisionShape.shape, "size", Vector3(x_size, 1, 5), 1)
		#tween.tween_property(extenderMesh, "position", Vector3(x_offset, 0, 0), 1).as_relative().from_current()
		#tween.tween_property(collisionShape, "position", Vector3(x_offset, 0, 0), 1).as_relative().from_current()
		#tween.tween_property(extenderMesh.mesh, "size", Vector3(x_size, 0, 0), 1).as_relative().from_current()
		#tween.tween_property(collisionShape.shape, "size", Vector3(x_size, 0, 0), 1).as_relative().from_current()
		extend = true
		shrink = false
		
		if (body is RigidBody3D):
			item_placed = true
		else:
			item_placed = false
			count += 1
			
	if (count < 1):
		current_body = body 
	

func _on_sensor_deactivate(body) -> void:
	if (body is RigidBody3D):
		item_placed = false
	if(!shrink and !item_placed and !level_completed and body == current_body): #  and body is CharacterBody3D
		print("detected extender deactivate!")
		var tween = get_tree().create_tween()
		tween.set_parallel()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(extenderMesh, "position", orignal_mesh_position, 1)
		tween.tween_property(collisionShape, "position", original_collision_position, 1)
		tween.tween_property(extenderMesh.mesh, "size", Vector3(3, 1, 5), 1)
		tween.tween_property(collisionShape.shape, "size", Vector3(3, 1, 5), 1)
		#tween.tween_property(extenderMesh, "position", Vector3(-x_offset, 0, 0), 1).as_relative().from_current()
		#tween.tween_property(collisionShape, "position", Vector3(-x_offset, 0, 0), 1).as_relative().from_current()
		#tween.tween_property(extenderMesh.mesh, "size", Vector3(-x_size, 0, 0), 1).as_relative().from_current()
		#tween.tween_property(collisionShape.shape, "size", Vector3(-x_size, 0, 0), 1).as_relative().from_current()
		shrink = true
		extend = false
		count = 0
	
