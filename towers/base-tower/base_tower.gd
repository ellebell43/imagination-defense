class_name Tower
extends MeshInstance3D

enum TargetMethod {FURTHEST, CLOSEST, STRONGEST, LAST}

@export var cost := 50
@export var target_method := TargetMethod.FURTHEST
@export var shoot_speed := 1.5
@export var projectile: PackedScene
@export var tower_range := 1.0

@onready var gui: GUI = get_tree().get_first_node_in_group("gui")
@onready var collision_texture: Material = preload("res://assets/textures/unshaded-red.tres")

@onready var tower_collision: Area3D = $TowerCollision
@onready var tower_range_area: Area3D = $TowerRange
@onready var shot_timer: Timer = $ShotTimer
@onready var barrel: MeshInstance3D = $Barrel
@onready var range_mesh: MeshInstance3D = $RangeMesh

var preview = false:
	set(new_preview):
		# remove from scene or charge cost when dropping out of preview
		if new_preview == false:
			if tower_collision.has_overlapping_bodies() or tower_collision.get_overlapping_areas():
				queue_free()
			else:
				gui.currency -= cost

var tower_material: Material
var shoot := false

func _ready() -> void:
	tower_material = material_override
	var tower_range_shape: CollisionShape3D = tower_range_area.get_child(0)
	tower_range_shape.shape.radius = tower_range
	range_mesh.mesh.radius = tower_range

func _process(_delta: float) -> void:
	if preview:
		if tower_collision.has_overlapping_bodies() or tower_collision.get_overlapping_areas():
			material_override = collision_texture
		else:
			material_override = tower_material
		
func _physics_process(_delta: float) -> void:
	var target = determine_target()
	if target and not preview:
		shoot = true
		look_at(target.global_position, Vector3.UP, true)
		rotation.x = 0
	else:
		shoot = false

func determine_target() -> PathFollow3D:
	var target: PathFollow3D = null
	var areas = tower_range_area.get_overlapping_areas()
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
		shot.global_position = barrel.global_position
		shot.direction = barrel.global_transform.basis.z
