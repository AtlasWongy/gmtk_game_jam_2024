extends MeshInstance3D

var rotating:bool = false
@export var level:int = 0 #0,1,2 etc
@export var game_over_menu: GameOverMenu

func _ready():
	SignalBus.change_face.connect(_on_flag_change_face)
	SignalBus.set_game_over_menu.connect(_on_set_game_over_menu)

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

func _on_set_game_over_menu(_is_game_over: bool):
	rotating = true
	var tween = get_tree().create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self,"global_rotation_degrees",global_rotation_degrees+Vector3(0,0,90.0),1).set_trans(Tween.TRANS_ELASTIC)
	tween.tween_callback(_set_rotating_false)
	tween.tween_callback(game_over_menu._on_set_game_over_menu)