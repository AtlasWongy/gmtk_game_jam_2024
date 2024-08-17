extends CharacterBody3D

var movement_direction: Vector3
var speed: float = 5.0
var acceleration: float = 1.0
var is_jumping: bool = false
var fall_gravity: int = 45
var jump_gravity: float = fall_gravity
var jump_height: float = 4.0
var apex_duration: float = 0.5

func _input(event: InputEvent) -> void:
	movement_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	
	if event.is_action_pressed("jump") and !is_jumping:
		is_jumping = true
		
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		if velocity.y >= 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
	if is_jumping and is_on_floor():
		jump()
		is_jumping = false
			
	if is_movement_ongoing():
		velocity.x = speed * movement_direction.normalized().x
	else:
		velocity.x = 0 * movement_direction.normalized().x
		
	velocity = velocity.lerp(velocity, acceleration * delta)
	move_and_slide()
		
func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0
	
func jump():
	velocity.y = 2 * jump_height / apex_duration
	jump_gravity = velocity.y / apex_duration
	
	