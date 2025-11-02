class_name GUI
extends Control

@export var starting_currency := 250
@export var max_health := 100

@onready var tower_manager: TowerManager = get_tree().get_first_node_in_group("tower_manager")

@onready var store_panel: Panel = $Store
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_label: Label = %HealthLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var currency_label: Label = %CurrencyLabel

var currency := 500:
	set(new_currency):
		currency = new_currency
		if currency < 0:
			currency = 0
		currency_label.text  = "Imagination: " + str(currency)

var health := 100:
	set(new_health):
		health = new_health
		if health < 0:
			health = 0
		health_bar.value = health
		health_label.text = str(health)

func _ready() -> void:
	currency = starting_currency
	health = max_health

func _on_store_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("show_store")
	else:
		animation_player.play("hide_store")

func _on_tower_test_button_down(source: BaseButton) -> void:
	tower_manager.tower_type = source.get_meta("tower")

func _on_tower_test_button_up() -> void:
	tower_manager.tower_type = tower_manager.TowerType.NULL
