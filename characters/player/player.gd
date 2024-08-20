extends CharacterBody3D
class_name Player

@export var box_type: GameManager.CurrentBox
@export var movement_stats: MovementStats
@export var poisoned_stats: MovementStats

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collisionShape: CollisionShape3D = $CollisionShape3D

var death_vfx = preload("res://objects/VFX/cube_death_vfx.tscn")

var movement_direction: Vector3
var can_control: bool = true

var is_grown:bool = false
var is_changing:bool = false
var is_shrunk:bool = true
var is_growing:bool = false #use for tracking super jumps
var grow_horizontal_direction:bool = false #false = left, true = right
var is_poison: bool = false

var is_landed:bool = true

var tween:Tween

func _ready() -> void:
	SignalBus.set_current_box.connect(_set_can_control)
	SignalBus.destroy_cube.connect(_destroy_cube)
	
	if GameManager.current_box != box_type:
		can_control = false

	mesh.mesh.material.emission_enabled = can_control
	movement_direction = Vector3(0,0,0)
	
	mesh.position.y = 0
	collisionShape.position.y = 0
	mesh.mesh.size = Vector3(0.5,0.5,0.5)
	collisionShape.shape.size = Vector3(0.5,0.5,0.5)


func _set_can_control():
	can_control = !can_control
	mesh.mesh.material.emission_enabled = can_control
	if !can_control:
		movement_direction = Vector3(0,0,0)


func _destroy_cube(cube:GameManager.CurrentBox):
	if cube==box_type:
		mesh.position.y = 0
		collisionShape.position.y = 0
		mesh.mesh.size = Vector3(0.5,0.5,0.5)
		collisionShape.shape.size = Vector3(0.5,0.5,0.5)

		var vfx = death_vfx.instantiate()
		GameManager.level_ref.add_child(vfx)
		vfx.global_position = global_position
		vfx.emitting = true
		call_deferred("queue_free")


func _input(event: InputEvent) -> void:
	
	if event.is_action_pressed("switch_box") and event.is_pressed() and GameManager.can_switch:
		SignalBus.set_current_box.emit()
		
	if event.is_action_released("switch_box") and event.is_released() and !GameManager.can_switch:
		SignalBus.set_enable_switch.emit()
	
	if is_poison:
		SignalBus.set_movement.emit(poisoned_stats, box_type)
		return
	
	if !can_control:
		return

	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		
		if is_movement_ongoing():
			SignalBus.set_movement.emit(movement_stats, box_type)
		else:
			SignalBus.set_movement.emit(null, box_type)
			
	if event.is_action_pressed("jump") and is_on_floor():
		SignalBus.pressed_jump.emit(box_type)
		
	if event.is_action_pressed("resize_left") and !is_changing:
		_resize_left()
		
	if (event.is_action_pressed("resize_up")) and !is_changing:
		_resize_up()

	if event.is_action_pressed("resize_right") and !is_changing:
		_resize_right()
		
	if (event.is_action_pressed("resize_down")) and !is_changing:
		_resize_down()
	
	
	
func _physics_process(_delta: float) -> void:
	if is_movement_ongoing():
		SignalBus.set_direction.emit(movement_direction, box_type)
	
	if !is_on_floor():
		is_landed = false
	if is_on_floor() and !is_landed:
		is_landed = true
		SignalBus.landing_sfx.emit()
		
func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0

func _resize_right():
	if (box_type == 0):
		grow_horizontal_direction = true
		is_growing = true
		is_changing = true

		if !is_grown:
			var tween = get_tree().create_tween()
			tween.set_parallel()
			_grow_animate(tween, 5, 0, "right")
		elif !is_shrunk:
			var tween = get_tree().create_tween()
			tween.set_parallel()
			_shrink_animate(tween, 5, 0, "right")
		
func _resize_left():
	if (box_type == 0):
		if !is_grown:
			is_changing = true
			var tween = get_tree().create_tween()
			tween.set_parallel()
			is_growing = true
			_grow_animate(tween, 5, 0, "left")
		elif !is_shrunk:
			is_changing = true
			var tween = get_tree().create_tween()
			tween.set_parallel()
			is_growing = true
			_shrink_animate(tween, 5, 0, "left")
			
func _resize_up():
	if !is_grown and box_type == 1:
		is_changing = true
		is_growing = true
		var tween = get_tree().create_tween()
		tween.set_parallel()
		_grow_animate(tween, 0, 5, "up")
	
func _resize_down():
	if !is_shrunk and box_type == 1:
		is_changing = true
		is_growing = true
		var tween = get_tree().create_tween()
		tween.set_parallel()
		_shrink_animate(tween, 0, 5, "up")

func _grow_animate(tween:Tween, x:float, y:float, direction:String):
	if direction == "right":
		tween.tween_property(mesh, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
	elif direction == "left":
		tween.tween_property(mesh, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
	tween.tween_property(mesh.mesh, "size", Vector3(x, y, 0), 1).as_relative().from_current()
	tween.tween_property(collisionShape.shape, "size", Vector3(x, y, 0), 1).as_relative().from_current()
	
	tween.connect("finished", on_grown)
	SignalBus.grow_sfx.emit()

func _shrink_animate(tween:Tween, x:float, y:float, direction:String):
	if direction == "right":
		tween.tween_property(mesh, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
	elif direction == "left":
		tween.tween_property(mesh, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
	tween.tween_property(mesh.mesh, "size", Vector3(-x, -y, 0), 1).as_relative().from_current()
	tween.tween_property(collisionShape.shape, "size", Vector3(-x, -y, 0), 1).as_relative().from_current()
	
	tween.connect("finished", on_shrunk)
	SignalBus.shrink_sfx.emit()

func on_shrunk():
	is_changing = false
	is_grown = false
	is_shrunk = true
	
func on_grown():
	is_changing = false
	is_grown = true
	is_shrunk = false
	is_growing = false
