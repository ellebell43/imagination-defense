class_name Tower
extends MeshInstance3D

@export var cost := 50

@onready var gui: GUI = get_tree().get_first_node_in_group("gui")
@onready var collision_texture: Material = preload("res://assets/textures/unshaded-red.tres")

@onready var tower_collision: Area3D = $TowerCollision

var preview = false:
	set(new_preview):
		# remove from scene or charge cost when dropping out of preview
		if new_preview == false:
			if tower_collision.has_overlapping_bodies() or tower_collision.get_overlapping_areas():
				queue_free()
			else:
				gui.currency -= cost

var tower_material: Material

func _ready() -> void:
	tower_material = material_override

func _process(_delta: float) -> void:
	if tower_collision.has_overlapping_bodies() or tower_collision.get_overlapping_areas():
		material_override = collision_texture
	else:
		material_override = tower_material
