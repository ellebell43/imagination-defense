class_name Enemy
extends PathFollow3D

var speed := 3.0
var health := 2

func _process(delta: float) -> void:
	progress += speed * delta # move along the path
	if progress_ratio >= 1:
		var gui: GUI = get_tree().get_first_node_in_group("gui")
		gui.health -= health
		queue_free()
