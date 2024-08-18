extends CharacterBody3D
class_name Player

@export var box_type: GameManager.CurrentBox
@export var movement_stats: MovementStats

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var collisionShape: CollisionShape3D = $CollisionShape3D

var death_vfx = preload("res://objects/VFX/cube_death_vfx.tscn")

var movement_direction: Vector3
var can_control: bool = true

var is_grown:bool = false
var is_changing:bool = false
var is_shrunk:bool = true

var tween:Tween

func _ready() -> void:
	
	SignalBus.set_current_box.connect(_set_can_control)
	SignalBus.destroy_cube.connect(_destroy_cube)
	
	if GameManager.current_box != box_type:
		can_control = false

	mesh.mesh.material.emission_enabled = can_control
	movement_direction = Vector3(0,0,0)


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
		
	if event.is_action_pressed("grow_left") and !is_changing:
		_grow_left()
		
	if (event.is_action_pressed("grow") or event.is_action_pressed("grow_right")) and !is_changing:
		_grow_right()

	if event.is_action_pressed("shrink_left") and !is_changing:
		_shrink_left()
		
	if (event.is_action_pressed("shrink") or event.is_action_pressed("shrink_right")) and !is_changing:
		_shrink_right()
	
	if event.is_action_pressed("switch_box") and event.is_pressed() and GameManager.can_switch:
		SignalBus.set_current_box.emit()
	
	if event.is_action_released("switch_box") and event.is_released() and !GameManager.can_switch:
		SignalBus.set_enable_switch.emit()
	
func _physics_process(_delta: float) -> void:
	if is_movement_ongoing():
		SignalBus.set_direction.emit(movement_direction, box_type)
# 		
# 	if is_on_ceiling():
# 		print("bonk")

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0

func _grow_right():
	if !is_grown:
		is_changing = true
		var tween = get_tree().create_tween()
		tween.set_parallel()
		
		if box_type == 1:
			_grow_animate(tween, 0, 5, "right")
		else:
			_grow_animate(tween, 5, 0, "right")
		
func _grow_left():
	if !is_grown:
		is_changing = true
		var tween = get_tree().create_tween()
		tween.set_parallel()
		if box_type == 1:
			_grow_animate(tween, 0, 5, "left")
		else:
			_grow_animate(tween, 5, 0, "left")
			
func _shrink_right():
	if !is_shrunk:
		is_changing = true
		var tween = get_tree().create_tween()
		tween.set_parallel()

		if box_type == 1:
			_shrink_animate(tween, 0, 5, "right")
		else:
			_shrink_animate(tween, 5, 0, "right")
	
func _shrink_left():
	if !is_shrunk:
		is_changing = true
		var tween = get_tree().create_tween()
		tween.set_parallel()

		if box_type == 1:
			_shrink_animate(tween, 0, 5, "left")
		else:
			_shrink_animate(tween, 5, 0, "left")

func _grow_animate(tween:Tween, x:float, y:float, direction:String):
	if direction == "right":
		tween.tween_property(mesh, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
	else:
		tween.tween_property(mesh, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
	tween.tween_property(mesh.mesh, "size", Vector3(x, y, 0), 1).as_relative().from_current()
	tween.tween_property(collisionShape.shape, "size", Vector3(x, y, 0), 1).as_relative().from_current()
	
	tween.connect("finished", on_grown)

func _shrink_animate(tween:Tween, x:float, y:float, direction:String):
	if direction == "right":
		tween.tween_property(mesh, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(x/2, y/2, 0), 1).as_relative().from_current()
	else:
		tween.tween_property(mesh, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
		tween.tween_property(collisionShape, "position", Vector3(-x/2, y/2, 0), 1).as_relative().from_current()
	tween.tween_property(mesh.mesh, "size", Vector3(-x, -y, 0), 1).as_relative().from_current()
	tween.tween_property(collisionShape.shape, "size", Vector3(-x, -y, 0), 1).as_relative().from_current()
	
	tween.connect("finished", on_shrunk)

func on_shrunk():
	is_changing = false
	is_grown = false
	is_shrunk = true
	
func on_grown():
	is_changing = false
	is_grown = true
	is_shrunk = false
