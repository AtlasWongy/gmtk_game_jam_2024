extends AudioStreamPlayer

func play_sound(sound_stream):
	print("playing")
	set_stream(sound_stream)
	connect("finished",remove_self)
	if is_inside_tree():
		play()

func remove_self():
	queue_free()
