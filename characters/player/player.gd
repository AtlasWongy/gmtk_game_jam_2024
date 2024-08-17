extends CharacterBody3D
class_name Player

@export var box_type: GameManager.CurrentBox
@export var movement_stats: MovementStats

var movement_direction: Vector3
var can_control: bool = true

func _ready() -> void:
	
	SignalBus.set_current_box.connect(_set_can_control)
	
	if GameManager.current_box != box_type:
		can_control = false

func _set_can_control():
	can_control = !can_control

func _input(event: InputEvent) -> void:
	
	if !can_control:
		return
	
	if event.is_action_pressed("switch_box") and event.is_pressed() and GameManager.can_switch:
		SignalBus.set_current_box.emit()
	
	if event.is_action_released("switch_box") and event.is_released() and !GameManager.can_switch:
		SignalBus.set_enable_switch.emit()

	if event.is_action("movement"):
		movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
		
		if is_movement_ongoing():
			SignalBus.set_movement.emit(movement_stats, box_type)
		else:
			SignalBus.set_movement.emit(null, box_type)
			
	if event.is_action_pressed("jump") and is_on_floor():
		SignalBus.pressed_jump.emit(box_type)
			
func _physics_process(_delta: float) -> void:
	if is_movement_ongoing():
		SignalBus.set_direction.emit(movement_direction, box_type)

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0
