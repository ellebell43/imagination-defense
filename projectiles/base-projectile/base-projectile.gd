class_name Projectile
extends MeshInstance3D

@onready var despawn_timer: Timer = $DespawnTimer

var direction := Vector3.FORWARD
var despawn_time := 2.0
var damage := 1 # used by enemy node
var speed := 3.0

func _ready() -> void:
	despawn_timer.wait_time = despawn_time
	
func _physics_process(delta: float) -> void:
	position += direction * delta * speed

func _on_despawn_timer_timeout() -> void:
	queue_free()
