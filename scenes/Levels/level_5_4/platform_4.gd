extends MeshInstance3D

@export var platform_5: MeshInstance3D
var tween: Tween

func _ready() -> void:
	platform_5._shift_platform_4.connect(_on_shift_platform_4)
	
func _on_shift_platform_4() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self, "position:y", 8.0, 2.0).as_relative().from_current()
	tween.tween_property(self, "rotation:z", 1.5708, 2.0).as_relative().from_current()
