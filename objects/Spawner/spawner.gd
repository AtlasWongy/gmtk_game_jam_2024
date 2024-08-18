extends Node3D

@export var cube_type: GameManager.CurrentBox
@export var active_spawner:bool = false
@export var level_id:int

@onready var marker = $Marker3D

var red_cube_scene = preload("res://characters/player/red_box/red_box.tscn")
var blue_cube_scene = preload("res://characters/player/blue_box/blue_box.tscn")


func _ready():
	SignalBus.spawn_cube.connect(_spawn_cube)

func _set_active_spawner():
	pass

func _spawn_cube(cube:GameManager.CurrentBox):

	if cube==cube_type:
		if cube_type==GameManager.CurrentBox.RED_BOX:

			var red_cube = red_cube_scene.instantiate()
			red_cube.global_position = marker.global_position
			GameManager.level_ref.add_child(red_cube)
		else:

			var blue_cube = blue_cube_scene.instantiate()
			blue_cube.global_position = marker.global_position
			GameManager.level_ref.add_child(blue_cube)
