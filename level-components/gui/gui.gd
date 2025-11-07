class_name GUI
extends Control

@export var starting_currency := 250
@export var max_health := 100
@export var tower_manager: TowerManager

@onready var store_panel: Panel = $Store
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var health_label: Label = %HealthLabel
@onready var health_bar: TextureProgressBar = %HealthBar
@onready var currency_label: Label = %CurrencyLabel
@onready var tower_buttons_grid: GridContainer = %TowerButtonsGrid
@onready var tower_details_panel: VBoxContainer = %TowerDetailsPanel

# cost labels
@onready var test_tower_cost_label: Label = %TestTowerCostLabel

var new_tower_type := TowerManager.TowerType.NULL # the TowerManager watches this variable to determine if a new tower should be made

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
	tower_buttons_grid.visible = true
	tower_details_panel.visible = false
	# set cost labels
	test_tower_cost_label.text = "Cost: " + str(tower_manager.test_tower_cost)
	test_tower_cost_label.set_meta("cost", tower_manager.test_tower_cost)

func _process(_delta: float) -> void:
	for item in get_tree().get_nodes_in_group("cost_labels"):
		if item is Label:
			var item_cost = item.get_meta("cost")
			if item_cost is int and item_cost > currency:
				item.label_settings.font_color = Color.RED
			else:
				item.label_settings.font_color = Color.WHITE

# toggle store panel visibility
func _on_store_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		animation_player.play("show_store")
	else:
		animation_player.play("hide_store")

func _on_tower_purchase_button_up() -> void:
	new_tower_type = TowerManager.TowerType.NULL 
	#tower_details_panel.visible = false

func _on_tower_purchase_button_down(tower_id: int) -> void:
	new_tower_type = tower_id as TowerManager.TowerType
	#tower_details_panel.visible = true

func _on_button_hover() -> void:
	pass
	
func _on_stop_button_hover() -> void:
	pass
