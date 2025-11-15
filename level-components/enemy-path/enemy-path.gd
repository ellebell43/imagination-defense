class_name EnemyPath
extends Path3D

enum EnemyType {TEST = -1, SHADOW = 1}

@export var spawn_time := 2
## Defines the difficulty of the game. Max domain defines the total number of rounds and max value defines the maximum difficulty a round can be. Min domain and value need to remain at 1
@export var difficulty_curve: Curve = preload("res://level-components/enemy-path/default-diff-curve.tres")
var total_rounds: int

@onready var spawn_timer: Timer = $SpawnTimer

var spawn_count: int: # initialized by start_round()
	set(new_count):
		if new_count <= 0: # end the current round once spawn count hits 0
			end_round()
		else:
			spawn_count = new_count

var in_round := false
var current_round := 1:
	set(new_round):
		if new_round > total_rounds: # end game once current round tries to go past total rounds
			end_game = true
			current_round = total_rounds
		else:
			current_round = new_round

var current_difficulty := 1.0
var end_game = false # watched by the gui

# Enemy scenes
var base_enemy := preload("res://enemies/base-enemy/base-enemy.tscn") # EenemyType.TEST

func _ready() -> void:
	spawn_timer.wait_time = spawn_time
	total_rounds = int(difficulty_curve.max_domain)
	difficulty_curve.min_value = 1
	start_round() # <- remove later

func start_round():
	in_round = true
	current_difficulty = difficulty_curve.sample(current_round)
	print("current difficulty: " + str(current_difficulty))
	spawn_count = int(current_difficulty * 4)

# things difficulty should affect:
# - enemy count for the round
# - enemy spawn curve/timeout
# - enemy types
# 	- an enemy's type will then determine their speed, health, and other variables

func end_round():
	in_round = false
	current_round += 1
	start_round() # <- remove later

func _on_spawn_timer_timeout() -> void:
	if in_round and spawn_count > 0:
		spawn_count -= 1
		var new_enemy: Enemy = base_enemy.instantiate()
		#new_enemy.speed *= current_difficulty
		add_child(new_enemy)
