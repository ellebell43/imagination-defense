class_name GUI
extends Control

@export var starting_currency := 250
@export var max_health := 100
@export var tower_manager: TowerManager
@export var enemy_path: EnemyPath

@onready var store_panel: Panel = $Store
@onready var health_label: Label = %HealthLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var currency_label: Label = %CurrencyLabel
@onready var tower_buttons_grid: GridContainer = %TowerButtonsGrid
@onready var round_label: Label = %RoundLabel

# cost labels
@onready var test_tower_cost_label: Label = %TestTowerCostLabel
@onready var goober_cost_label: Label = %GooberCostLabel

var new_tower_type := TowerManager.TowerType.NULL # the TowerManager watches this variable to determine if a new tower should be made

var currency := 500:
	set(new_currency):
		currency = new_currency
		if currency < 0:
			currency = 0
		currency_label.text  = "Imagination: " + str(currency)

var health := 100:
	set(new_health):
		if new_health <= 0:
			end_game()
			health = 0
		else:
			health = new_health
		health_bar.value = health
		health_label.text = str(health)

func _ready() -> void:
	currency = starting_currency
	health = max_health
	# set cost labels
	test_tower_cost_label.text = "Cost: " + str(tower_manager.test_tower_cost)
	test_tower_cost_label.set_meta("cost", tower_manager.test_tower_cost)
	goober_cost_label.text = "Cost: " + str(tower_manager.goober_cost)
	goober_cost_label.set_meta("cost", tower_manager.goober_cost)

func _process(_delta: float) -> void:
	if enemy_path.end_game:
		end_game()
	for item in get_tree().get_nodes_in_group("cost_labels"):
		if item is Label:
			var item_cost = item.get_meta("cost")
			if item_cost is int and item_cost > currency:
				item.label_settings.font_color = Color.RED
			else:
				item.label_settings.font_color = Color.WHITE
	round_label.text = "Round " + str(enemy_path.current_round) + " of " + str(enemy_path.total_rounds)

func _on_tower_purchase_button_up() -> void:
	new_tower_type = TowerManager.TowerType.NULL 
	#tower_details_panel.visible = false

func _on_tower_purchase_button_down(tower_id: int) -> void:
	new_tower_type = tower_id as TowerManager.TowerType
	#tower_details_panel.visible = true
	
func end_game() -> void:
	print("game over")
