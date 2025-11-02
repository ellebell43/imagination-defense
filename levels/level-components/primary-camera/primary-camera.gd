class_name PrimaryCamera
extends Camera3D

@onready var mouse_ray: RayCast3D = $MouseRay

## Point the MouseRay at the mouse pointer and extend 30m
func cast_at_pointer() -> void:
	var mouse_position := get_viewport().get_mouse_position() # get mouse position
	mouse_ray.target_position = project_local_ray_normal(mouse_position) * 50 # cast towards mouse pointer and extend 50m
	mouse_ray.force_raycast_update() # force raycast to update
	
func _process(_delta: float) -> void:
	cast_at_pointer()
