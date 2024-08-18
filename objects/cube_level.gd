extends MeshInstance3D

var rotating:bool = false
@export var level:int = 0 #0,1,2 etc

func _ready():
	SignalBus.change_face.connect(_on_flag_change_face)

func flag_reached():
	rotating = true
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self,"global_rotation_degrees",global_rotation_degrees+Vector3(0,-90,0),1).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(_set_rotating_false)

func _set_rotating_false():
	rotating = false

func _on_flag_change_face() -> void:
	if(!rotating):
		flag_reached()
