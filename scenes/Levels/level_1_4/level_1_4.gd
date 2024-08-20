extends Node

var movable_item
var movable_item_position

var gate
var gate_position

# Called when the node enters the scene tree for the first time.
func _ready():
	movable_item = $MovableItem
	movable_item_position = movable_item.get_position()
	gate = $Gate
	gate_position = gate.get_position()
	SignalBus.reset_level.connect(_reset_items)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _reset_items():
	print("reset_level_1_4")
	movable_item.set_position(movable_item_position)
	gate.set_position(gate_position)
