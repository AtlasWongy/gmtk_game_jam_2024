extends PanelContainer
class_name TimeCounter

@export var time_label: Label

var start_time = 0
var current_time = 0
var elapsed_time_minutes = 0
var elapsed_time_secs = 0
var elapsed_time = 0

func _ready() -> void:
	start_time = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	
func _process(_delta: float) -> void:
	if GameManager.game_state == GameManager.GameState.PAUSED or GameManager.game_state == GameManager.GameState.NOT_STARTED:
		return
	current_time = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system())
	elapsed_time = current_time - start_time
	elapsed_time_minutes = elapsed_time / 60.0
	elapsed_time_secs = elapsed_time % 60
	var str_elapsed = "%02d : %02d" % [elapsed_time_minutes, elapsed_time_secs]
	time_label.text = str_elapsed
	
	


	
