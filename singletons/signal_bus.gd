extends Node

signal set_movement(_movement_stats: MovementStats, box_type:int)
signal set_direction(_movement_direction: Vector3, box_type:int)
signal pressed_jump(box_type:int)
signal set_current_box()
signal set_enable_switch()
signal pressed_grow(box_type:int)
signal set_expansion()
signal set_shrink()
signal set_game_state(_game_state: GameManager.GameState)
signal set_pause_menu(_pause_menu_state: bool)
signal set_game_over_menu(_game_over_menu_state: int)
