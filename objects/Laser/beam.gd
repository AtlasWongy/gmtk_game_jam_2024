extends Node3D

@onready var mesh = $RayCast3D/Beam
@onready var raycast = $RayCast3D
@onready var particles = $RayCast3D/GPUParticles3D

@export var laser_id:int = 0
var blocked:bool = false

signal laser_blocked(id:int)
signal laser_not_blocked(id:int)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var object = raycast.get_collider()
	var hitpt = raycast.to_local(raycast.get_collision_point())

	if(object):
		mesh.mesh.height = hitpt.y
		mesh.position.y = hitpt.y/2
		particles.position.y = hitpt.y
		if(object is Player):
			laser_blocked.emit(laser_id)
			blocked = true
		else:
			laser_not_blocked.emit(laser_id)
			blocked = false

	else:
		hitpt = Vector3(0,50,0)
		mesh.mesh.height = hitpt.y
		mesh.position.y = hitpt.y/2
		particles.position.y = hitpt.y
		laser_not_blocked.emit(laser_id)
		blocked = false
