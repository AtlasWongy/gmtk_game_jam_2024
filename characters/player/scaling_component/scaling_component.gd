extends Node3D
class_name ScalingComponent

@export var mesh: MeshInstance3D
@export var collision_shape: CollisionShape3D

var tween: Tween

func _ready() -> void:
	SignalBus.set_expansion.connect(_on_set_expansion)
	
func _on_set_expansion() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(mesh.mesh, "size:x", 5, 1).as_relative().from_current()
	tween.tween_property(collision_shape, "size:x", 5, 1).as_relative().from_current()
	
func _on_set_shrink() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_parallel()
	
	tween.tween_property(mesh.mesh, "size:x", -5, 1).as_relative().from_current()
	tween.tween_property(collision_shape, "size:x", -5, 1).as_relative().from_current()
	
