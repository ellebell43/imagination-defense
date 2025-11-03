class_name Projectile
extends MeshInstance3D

@export var despawn_time := 2.0
@export var damage := 1
@export var speed := 3.0

@onready var despawn_timer: Timer = $DespawnTimer

var direction := Vector3.FORWARD

func _ready() -> void:
	despawn_timer.wait_time = despawn_time
	
func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_despawn_timer_timeout() -> void:
	queue_free()
