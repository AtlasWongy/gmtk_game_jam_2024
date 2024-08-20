extends Node

@onready var player = preload("res://scenes/SFXOneShot/SFXOneShot.tscn")

var super_jump_sfx = preload("res://assets/sfx/jump5.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.pressed_super_jump.connect(_on_super_jump)
	
func _on_super_jump():
	var sfx = player.instantiate()
	get_tree().get_root().add_child(sfx)
	sfx.play_sound(super_jump_sfx)
	sfx.volume_db = -16
