extends Node

signal set_movement(_movement_stats: MovementStats, box_type:int)
signal set_direction(_movement_direction: Vector3, box_type:int)
signal pressed_jump(box_type:int)
signal set_current_box()
signal set_enable_switch()
signal pressed_grow(box_type:int)
signal spawn_cube(cube:GameManager.CurrentBox, level:int)
signal destroy_cube()
signal register_level(node3d:Node3D)
signal set_expansion()
signal set_shrink()
signal set_game_state(_game_state: GameManager.GameState)
signal set_pause_menu(_pause_menu_state: bool)
signal set_game_over_menu(_game_over_menu_state: bool)
signal send_completion_time(_completion_time: String)
signal level_complete()
signal change_face()
signal get_camera(camera:Camera3D)
signal pressed_super_jump()
signal transition_next_level()
