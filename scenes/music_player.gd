extends AudioStreamPlayer

var skybox_song_2 = preload("res://assets/music/Skybox 2.wav")

func _ready():
	SignalBus.transition_next_level.connect(_change_songs)

func _change_songs():
	var tween = get_tree().create_tween()
	tween.tween_property(self,"volume_db",-60,3)
	await tween.finished
	stream = skybox_song_2
	volume_db = 0
	play()
