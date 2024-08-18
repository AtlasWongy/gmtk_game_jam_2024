extends Node

signal set_movement(_movement_stats: MovementStats, box_type:int)
signal set_direction(_movement_direction: Vector3, box_type:int)
signal pressed_jump(box_type:int)
signal set_current_box()
signal set_enable_switch()
signal pressed_grow(box_type:int)
signal spawn_cube()
signal destroy_cube()
signal register_level(node3d:Node3D)
