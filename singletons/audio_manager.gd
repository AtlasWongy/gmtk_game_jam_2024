extends Node

@onready var player = preload("res://scenes/SFXOneShot/SFXOneShot.tscn")

var super_jump_sfx = preload("res://assets/sfx/superjump.wav")
var jump_sfx = preload("res://assets/sfx/jump.wav")
var grow_sfx = preload("res://assets/sfx/grow.wav")
var shrink_sfx = preload("res://assets/sfx/shrink.wav")
var death_sfx = preload("res://assets/sfx/death.wav")
var complete_sfx = preload("res://assets/sfx/level_complete.wav")

var interactable_1 = preload("res://assets/sfx/interactable_1.wav")
var interactable_2 = preload("res://assets/sfx/interactable_2.wav")
var interactable_3 = preload("res://assets/sfx/interactable_3.wav")

var switch_sfx = preload("res://assets/sfx/switch.wav")

var respawn_sfx = preload("res://assets/sfx/respawn.wav")
var landing_sfx = preload("res://assets/sfx/landing.wav")

var interactable_sfx = [interactable_1,interactable_2,interactable_3]

var can_play_run_sfx: bool = true #controlled by timer
@onready var root = get_tree().get_root()

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.pressed_super_jump.connect(_on_super_jump)
	SignalBus.pressed_jump_sfx.connect(_on_jump)
	SignalBus.grow_sfx.connect(_grow)
	SignalBus.shrink_sfx.connect(_shrink)
	SignalBus.level_complete.connect(_complete)
	SignalBus.death_sfx.connect(_death)
	SignalBus.interactable_sfx.connect(_interactable)
	SignalBus.on_press_switch.connect(_on_switch)
	SignalBus.respawn_sfx.connect(_on_respawn)
	SignalBus.landing_sfx.connect(_on_landing)
	
func _on_super_jump():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(super_jump_sfx)

func _on_jump():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(jump_sfx)
	sfx.volume_db = -32
	sfx.pitch_scale = randf_range(0.8,1.2)

func _grow():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(grow_sfx)
	sfx.pitch_scale = randf_range(0.8,1.2)

func _shrink():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(shrink_sfx)
	sfx.pitch_scale = randf_range(0.8,1.2)

func _death():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(death_sfx)
	
func _complete():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(complete_sfx)

func _interactable():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(interactable_sfx[randi_range(0,2)])

func _on_switch():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(switch_sfx)

func _on_respawn():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(respawn_sfx)

func _on_landing():
	var sfx = player.instantiate()
	root.add_child(sfx)
	sfx.play_sound(landing_sfx)
	sfx.volume_db = -32
	sfx.pitch_scale = randf_range(0.8,3)
	
