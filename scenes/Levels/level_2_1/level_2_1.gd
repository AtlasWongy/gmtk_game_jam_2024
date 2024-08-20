extends Node3D
#idea: block lasers? idk man

@onready var gate = $GrayGate
@onready var laser = $Laser2
@onready var platform = $Platform10
@onready var flag_platform = $Platform4

var gate_up: bool = false
var laser_rotated:bool = false
var platform_up:bool = false

var flag_opened:bool = false

const gate_down_coords = Vector3(-8.5,12,0)
const gate_up_coords = Vector3(-8.5,14,0)

const platform_up_coords = Vector3(-2.15,7.5,0)
const platform_down_coords = Vector3(-2.15,6.5,0)

func _physics_process(delta:float):
	if(GameManager.level_id != 2):
		return
	
	if(gate_up):
		gate.position = gate.position.move_toward(gate_up_coords,delta*5)
	else:
		gate.position = gate.position.move_toward(gate_down_coords,delta*5)
	
	if(laser_rotated):
		if(laser.rotation_degrees.x <= 0.1 and laser.rotation_degrees.x > -90):
			laser.rotation_degrees += Vector3(max(-90-laser.rotation_degrees.x,-5),0,0)

	elif !laser_rotated:
		if laser.rotation_degrees.x < 0.1 and laser.rotation_degrees.x >= -90:
			laser.rotation_degrees += Vector3(min(-laser.rotation_degrees.x,5),0,0)
	
	if(platform_up):
			platform.position = platform.position.move_toward(platform_up_coords,delta*5)
	else:
		platform.position = platform.position.move_toward(platform_down_coords,delta*5)
	
	if(flag_opened):
		flag_platform.position = flag_platform.position.move_toward(Vector3(5,6.5,0),delta*5)

func _on_laser_blocked(id: int) -> void:
	if(id==0):
		print("LAZER ME")
		gate_up = true
	elif(id==1):
		laser_rotated = true
	elif(id==2):
		platform_up = true
	elif(id==3):
		if(laser_rotated):
			flag_opened = true

func _on_laser_not_blocked(id: int) -> void:
	if(id==0):
		gate_up = false
	elif(id==1):
		laser_rotated = false
	elif(id==2):
		platform_up = false
