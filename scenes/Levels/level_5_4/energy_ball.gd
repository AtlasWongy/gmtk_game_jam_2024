extends StaticBody3D

var tween: Tween

func _ready() -> void:
	tween = create_tween()
	tween.tween_property(self, "global_position:x", 4.0, 1.0).as_relative().from_current()


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Hello")
