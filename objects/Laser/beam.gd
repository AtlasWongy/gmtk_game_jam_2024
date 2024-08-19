extends RayCast3D

@onready var mesh = $Beam
@onready var particles = $GPUParticles3D


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var object = get_collider()
	var hitpt = to_local(get_collision_point())

	if(object):
		mesh.mesh.height = hitpt.y
		mesh.position.y = hitpt.y/2
		particles.position.y = hitpt.y
		
