extends Node

enum CurrentBox {RED_BOX, BLUE_BOX}

var current_box

func _ready() -> void:
	current_box = CurrentBox.RED_BOX