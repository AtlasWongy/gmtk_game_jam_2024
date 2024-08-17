extends Node

signal set_movement(_movement_stats: MovementStats, box_type:int)
signal set_direction(_movement_direction: Vector3, box_type:int)
signal pressed_jump(box_type:int)
signal set_current_box()
signal set_enable_switch()
signal set_expansion()
signal set_shrink()
