extends Node

var sfx = preload("res://scenes/SFXOneShot.tscn")
var jump_sfx = preload("res://assets/sfx/fish_spawn.wav")

#preload your sfx here
func _ready():
	SignalBus.pressed_jump.connect(_play_jump_sfx)

func _play_jump_sfx(box_type:int):
	var new_sfx = sfx.instantiate()
	get_tree().current_scene.add_child(new_sfx)
	new_sfx.volume_db = -24
	new_sfx.play_sound(jump_sfx)
