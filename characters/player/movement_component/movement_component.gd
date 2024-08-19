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
var _box_type:int

var super_jump:bool = false
#do hammer style over acceleration deceleration here?

func _ready() -> void:
	_box_type = get_parent().box_type
	SignalBus.set_movement.connect(_on_set_movement)
	SignalBus.set_direction.connect(_on_set_direction)
	SignalBus.pressed_jump.connect(_on_pressed_jump)
	
	
func _physics_process(delta: float) -> void:
	
	if !player.can_control:
		direction = Vector3(0,0,0)
	
	if abs(velocity.x) > speed+10:
		if direction.normalized().x > 0:
			velocity.x = max(speed * direction.normalized().x,  0.95 * velocity.x)
		else:
			velocity.x = min(speed * direction.normalized().x,  0.95 * velocity.x)
	else:
		velocity.x = speed * direction.normalized().x
	
	if super_jump:
		velocity.x += 30
		super_jump = false
	
	if not player.is_on_floor():
		if player.is_on_ceiling():
			velocity.y = 0
		elif velocity.y >= 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
	
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	
func _on_set_movement(_movement_stats: MovementStats, box_type:int):
	if(box_type != _box_type):
		return
		
	if !_movement_stats:
		speed = 0.0
		acceleration = 6.0
	else:
		speed = _movement_stats.speed
		acceleration = _movement_stats.acceleration
	
func _on_set_direction(_direction: Vector3, box_type:int):
	if(box_type != _box_type):
		return
	direction = _direction
	
func _on_pressed_jump(box_type:int):
	if(box_type != _box_type):
		return
	velocity.y = 2 * jump_height / apex_duration
	for i in player.get_slide_collision_count():
		var col = player.get_slide_collision(i)

		if col.get_collider() is Player:
			var player_col: Player = col.get_collider()
			if player_col.is_changing and player_col.is_growing:
				if player_col.box_type == 1:
					velocity.y += 60
					print("bonus jump")
				else:
					super_jump = true
					print("bonus horizontal jump")
				
			print("touching player while jumping")
			

	jump_gravity = velocity.y / apex_duration
