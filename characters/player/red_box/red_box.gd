extends CharacterBody3D
class_name Player

@export var movement_stats: MovementStats

var movement_direction: Vector3

func _input(event: InputEvent) -> void:
	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		
		if is_movement_ongoing():
			SignalBus.set_movement.emit(movement_stats)
		else:
			SignalBus.set_movement.emit(null)
			
	if event.is_action_pressed("jump") and is_on_floor():
		SignalBus.pressed_jump.emit()
			
func _physics_process(_delta: float) -> void:
	if is_movement_ongoing():
		SignalBus.set_direction.emit(movement_direction)

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0
	
	
