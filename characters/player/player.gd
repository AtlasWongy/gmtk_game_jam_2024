extends CharacterBody3D
class_name Player

@export var box_type: GameManager.CurrentBox
@export var movement_stats: MovementStats

var movement_direction: Vector3
var can_control: bool = true

func _ready() -> void:
	print(GameManager.current_box)
	if GameManager.current_box != box_type:
		can_control = false
		print(box_type)

func _input(event: InputEvent) -> void:
	
	if !can_control:
		return
	
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
