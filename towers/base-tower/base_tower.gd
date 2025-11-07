class_name Tower
extends MeshInstance3D

enum TargetMethod {FURTHEST, CLOSEST, STRONGEST, LAST}

# exported variables
var cost := 50
@export var target_method := TargetMethod.FURTHEST
@export var shoot_speed := 0.5
@export var projectile_speed := 8.0
@export var projectile: PackedScene
@export var tower_range := 0.6
@export var damage := 1

# nodes from the scene tree
@onready var gui: GUI = get_tree().get_first_node_in_group("gui")

# texture references
@onready var collision_texture: Material = preload("res://assets/textures/unshaded-red.tres")
@onready var range_blue: Material = preload("res://assets/textures/tower_range_blue.tres")
@onready var range_red: Material = preload("res://assets/textures/tower_range_red.tres")

# children references
@onready var collision_area: Area3D = $TowerCollision
@onready var range_area: Area3D = $TowerRange
@onready var range_mesh: MeshInstance3D = $RangeMesh
@onready var shot_timer: Timer = $ShotTimer
@onready var barrel: MeshInstance3D = $Barrel

var preview = false: 
	set(new_preview):
		preview = new_preview
		# remove from scene or charge cost and hide range when dropping out of preview
		if preview == false:
			if collision_area.has_overlapping_bodies() or collision_area.get_overlapping_areas():
				queue_free()
			else:
				gui.currency -= cost
				range_mesh.visible = false
				shoot = true

var tower_material := material_override
var shoot := false

func _ready() -> void:
	var tower_range_shape: CollisionShape3D = range_area.get_child(0)
	tower_range_shape.shape.radius = tower_range
	range_mesh.mesh.radius = tower_range
	shot_timer.wait_time = shoot_speed

func _process(_delta: float) -> void:
	if preview:
		if collision_area.has_overlapping_bodies() or collision_area.get_overlapping_areas():
			material_override = collision_texture
			range_mesh.material_override = range_red
		else:
			material_override = tower_material
			range_mesh.material_override = range_blue
		
func _physics_process(_delta: float) -> void:
	var target = determine_target()
	if target and not preview:
		look_at(target.global_position, Vector3.UP, true)
		rotation.x = 0
		shoot = true
	else:
		shoot = false

func determine_target() -> PathFollow3D:
	var target: PathFollow3D = null
	var areas = range_area.get_overlapping_areas()
	for item in areas:
		var entity = item.get_parent()
		if entity is Enemy:
			match target_method:
				TargetMethod.LAST: # shoot enemy furthest behind
					if not target or target.progress > entity.progress:
						target = entity
				TargetMethod.CLOSEST: #shoot closest enemy
					if not target or entity.position.distance_to(position) < target.position.distance_to(position):
						target = entity
				TargetMethod.STRONGEST: # shoot strongest enemy
					if not target or entity.health > target.heatlh:
						target = entity
				_:  # shoot enemy furthest along (DEFAULT)
					if not target or target.progress < entity.progress:
						target = entity
	return target

func _on_shot_timer_timeout() -> void:
	if shoot:
		var shot: Projectile = projectile.instantiate()
		add_child(shot)
		shot.speed = projectile_speed
		shot.damage = damage
		shot.global_position = barrel.global_position
		shot.direction = barrel.global_transform.basis.z
