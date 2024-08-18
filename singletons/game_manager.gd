extends Node

enum CurrentBox {RED_BOX, BLUE_BOX}

var current_box: CurrentBox

var can_switch:bool = true

var level_ref: Node3D #used for spawners to spawn new cubes in

func _ready() -> void:
	current_box = CurrentBox.RED_BOX
	SignalBus.set_current_box.connect(_disable_switch)
	SignalBus.set_enable_switch.connect(_enable_switch)
	SignalBus.register_level.connect(_register_level)

func _disable_switch():
	can_switch = false

func _enable_switch():
	can_switch = true
	
func _register_level(level:Node3D):
	
	level_ref = level
	print(level)
