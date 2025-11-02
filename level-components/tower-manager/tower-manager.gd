class_name TowerManager
extends Node3D

@export var primary_camera: PrimaryCamera

@onready var base_tower_scene = preload("res://towers/base-tower/base-tower.tscn")

enum TowerType {
	TEST = -1,
	NULL = 0
}

var tower_type: TowerType # is set from gui
var tower_instantiated := false # tracks if the tower has been created yet
var new_tower: Tower # ref to new tower

func _process(_delta: float) -> void:
	# create a tower if the type has been set (gui button pressed) and the tower hasn't already been created
	if not tower_type == TowerType.NULL and not tower_instantiated:
		create_tower()
	
	# If the tower type is set and the tower is create, move the tower with the mouse
	if not tower_type == TowerType.NULL and tower_instantiated:
		new_tower.position = primary_camera.mouse_ray.get_collision_point()
		new_tower.position.y = -.25 # not sure why the towers hover .2m off the ground, but this fixes it
	
	# If tower type is null (released gui button), drop tower out of preview mode and clear tower creation status
	if tower_instantiated and tower_type == TowerType.NULL:
		new_tower.preview = false
		tower_instantiated = false

func create_tower() -> void:
	match tower_type:
		TowerType.TEST:
			new_tower = base_tower_scene.instantiate()
		_:
			new_tower = base_tower_scene.instantiate()
	
	add_child(new_tower)
	new_tower.position = primary_camera.mouse_ray.get_collision_point()
	new_tower.preview = true
	tower_instantiated = true
