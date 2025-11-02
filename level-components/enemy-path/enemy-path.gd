class_name EnemyPath
extends Path3D

@export var enemy: PackedScene
@export var spawn_time := 2

@onready var spawn_timer: Timer = $SpawnTimer

var spawn_count := 0

func _ready() -> void:
	spawn_timer.wait_time = spawn_time

func _on_spawn_timer_timeout() -> void:
	spawn_count += 1
	var new_enemy: Enemy = enemy.instantiate()
	add_child(new_enemy)
