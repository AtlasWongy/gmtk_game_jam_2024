extends Node3D

const spawner_colors = ["#994849","#58a65c"]

@export var cube_type: GameManager.CurrentBox
@export var active_spawner:bool = false
@export var level_id:int

@onready var marker = $Marker3D
@onready var mesh:MeshInstance3D = $MeshInstance3D

var red_cube_scene = preload("res://characters/player/red_box/red_box.tscn")
var blue_cube_scene = preload("res://characters/player/blue_box/blue_box.tscn")


func _ready():
	SignalBus.spawn_cube.connect(_spawn_cube)
	print(cube_type)
	mesh.mesh.material.albedo_color = spawner_colors[cube_type]

func _set_active_spawner():
	pass

func _spawn_cube(cube:GameManager.CurrentBox):

	if cube==cube_type:
		if cube_type==GameManager.CurrentBox.RED_BOX:

			var red_cube = red_cube_scene.instantiate()
			GameManager.level_ref.add_child(red_cube)
			red_cube.global_position = marker.global_position

		else:

			var blue_cube = blue_cube_scene.instantiate()
			GameManager.level_ref.add_child(blue_cube)
			blue_cube.global_position = marker.global_position
