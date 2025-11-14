class_name TowerManager
extends Node3D

enum TowerType {
	TEST = -1,
	NULL = 0,
	GOOBER = 1
}

@export var primary_camera: PrimaryCamera
@export var gui: GUI
@export var test_tower_cost: int = 50
@export var goober_cost: int = 25

# tower scenes
@onready var test_tower_scene = preload("res://towers/test-tower/test-tower.tscn")
@onready var goober_scene = preload("res://towers/goober/goober.tscn")

var new_tower: Tower # ref to new tower
var new_tower_type := TowerType.NULL:
	set(type):
		new_tower_type = type
		if not type == TowerType.NULL and not new_tower:
			create_tower(type)
		if type == TowerType.NULL and new_tower: # drop tower out of preview and clear new_tower ref
			new_tower.preview = false
			new_tower = null

func _process(_delta: float) -> void:
	self.new_tower_type = gui.new_tower_type # sync TowerManager and GUI new_tower_type
	
	# If the there's a new tower and it's in preview, move it with the mouse
	if new_tower and new_tower.preview:
		new_tower.position = primary_camera.mouse_ray.get_collision_point()
		new_tower.position.y = -.25 # not sure why the towers hover .2m off the ground, but this fixes it

func create_tower(tower_type: TowerType) -> void:
	# determine what type of tower needs instantiating
	match tower_type:
		TowerType.NULL:
			return
		TowerType.GOOBER:
			new_tower = goober_scene.instantiate()
			new_tower.cost = goober_cost
		_:
			new_tower = test_tower_scene.instantiate()
			new_tower.cost = test_tower_cost
	
	# create tower if player has enough currency, else remove tower instance
	if gui.currency >= new_tower.cost:
		add_child(new_tower)
		new_tower.position = primary_camera.mouse_ray.get_collision_point()
		new_tower.preview = true
	else:
		new_tower.free()
		new_tower = null
