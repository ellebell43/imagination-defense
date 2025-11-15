class_name Enemy
extends PathFollow3D

@export var speed := 0.5
@export var reward := 10
@export var health := 2:
	set(new_health):
		health = new_health
		if health <= 0:
			gui.currency += reward
			queue_free()

@onready var gui: GUI = get_tree().get_first_node_in_group("gui")

func _process(delta: float) -> void:
	progress += speed * delta # move along the path
	if progress_ratio >= 1:
		gui.health -= health
		queue_free()


func _on_area_3d_area_entered(area: Area3D) -> void:
	var projectile = area.get_parent()
	if projectile is Projectile:
		health -= projectile.damage
		projectile.queue_free()
