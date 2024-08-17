extends Node3D
class_name MovementComponent

@export var player: CharacterBody3D
@export var fall_gravity: float = 45
@export var jump_height: float
@export var apex_duration: float

var velocity: Vector3
var direction: Vector3
var speed: float
var acceleration: float = 6.0
var jump_gravity: float = fall_gravity

func _ready() -> void:
	SignalBus.set_movement.connect(_on_set_movement)
	SignalBus.set_direction.connect(_on_set_direction)
	SignalBus.pressed_jump.connect(_on_pressed_jump)
	
func _physics_process(delta: float) -> void:
	velocity.x = speed * direction.normalized().x
	
	if not player.is_on_floor():
		if velocity.y >= 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	
func _on_set_movement(_movement_stats: MovementStats):
	if !_movement_stats:
		speed = 0.0
		acceleration = 6.0
	else:
		speed = _movement_stats.speed
		acceleration = _movement_stats.acceleration
	
func _on_set_direction(_direction: Vector3):
	direction = _direction
	
func _on_pressed_jump():
	velocity.y = 2 * jump_height / apex_duration
	jump_gravity = velocity.y / apex_duration
	
