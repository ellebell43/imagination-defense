class_name Enemy
extends PathFollow3D

var speed := 3.0

func _process(delta: float) -> void:
	progress += speed * delta # move along the path
	if progress_ratio >= 1:
		queue_free()
