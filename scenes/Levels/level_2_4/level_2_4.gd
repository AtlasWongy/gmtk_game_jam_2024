extends Node

var movable_item_3
var movable_item_position_3

var movable_item_2
var movable_item_2_position

var gate
var gate_position

# Called when the node enters the scene tree for the first time.
func _ready():
	movable_item_3 = $MovableItem3
	movable_item_position_3 = movable_item_3.get_position()
	movable_item_2 = $MovableItem2
	movable_item_2_position = movable_item_2.get_position()
	gate = $Gate
	gate_position = gate.get_position()
	SignalBus.reset_level.connect(_reset_items)
	print(movable_item_position_3)
	print(movable_item_2_position)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _reset_items():
	print("reset_level_2_4")
	movable_item_3.set_position(movable_item_position_3)
	movable_item_2.set_position(movable_item_2_position)
	gate.set_position(gate_position)
	gate.open = false
	gate.count = 0
