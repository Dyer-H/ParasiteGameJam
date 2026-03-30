extends Control

#this should always be selectable menu items
@onready var description = $TextureRect/DescriptionBackground/MarginContainer/ItemDescription
@onready var upgradeButton = $TextureRect/DescriptionBackground/UpgradeButton
@onready var upgradeButtonLabel = $TextureRect/DescriptionBackground/UpgradeButton/UpgradeButtonLabel
@onready var itemBox = $TextureRect/ScrollContainer/GridContainer

const selectable_menu_item = preload("res://HUDLayer/Menu/Scenes/selectable_menu_item.tscn")
var stats = preload("res://PlayerControl/Resources/player_stats.tres")
var isItemSelected = false
var selectedItem = 0

#Can rearrange these
#Will change positions of menu items
#Do not change names 
enum ItemPositions{
	HEALTH_ITEM,
	STAM_ITEM,
	DAMAGE_ITEM,
	RANGE_ITEM,
	CRIT_ITEM,
	DASH_ITEM,
	SPEED_ITEM
}

#updated by _create_selectable_menu_items
var menu_items: Array[Node]

#function populates menu items once initially
func _ready() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	_populate_menu_items()
	

#function listens for Toggle Menu input and shows/closes menu accordingly
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Menu"):
		if self.visible == true:
			if isItemSelected:
				menu_items[selectedItem].toggle_selection()
				_clear_description_field()
				isItemSelected = false
			self.visible = false
			_resume_game()
			return
		self.visible = true
		_pause_game()

#this happens every time a menu item (left two boxes) are clicked
func _on_item_clicked(menu_item) -> void:
	var pos = menu_items.find(menu_item)
	if !isItemSelected:
		menu_item.toggle_selection()
		_set_description_field(menu_item.item)
		selectedItem = pos
		isItemSelected = true
		return
	if pos == selectedItem:
		menu_item.toggle_selection()
		_clear_description_field()
		isItemSelected = false
		return
	menu_items[selectedItem].toggle_selection()
	menu_item.toggle_selection()
	_set_description_field(menu_item.item)
	selectedItem = pos

#this happens every time the upgrade button is clicked
func _on_upgrade_button_clicked() -> void:
	var current_selection = menu_items[selectedItem]
	var price = current_selection.item.price
	stats.set_coins(stats.coins - price)
	match selectedItem:
		0:
			stats.increment_weapon_level()
		1:
			stats.increment_suit_level()
	current_selection.toggle_selection()
	_clear_description_field()
	_update_menu_item()
	isItemSelected = false

#populates menu items at ready
func _populate_menu_items() -> void:
	_create_selectable_menu_items()
	_set_initial_menu_items()

func _create_selectable_menu_items() -> void:
	var num_item_positions = ItemPositions.keys().size()
	for i in range(num_item_positions):
		var new_selectable_menu_item = selectable_menu_item.instantiate()
		new_selectable_menu_item.custom_minimum_size = Vector2(1000, 122) #1000 is number from scroll container size, 122 is good looking height
		itemBox.add_child(new_selectable_menu_item)
	menu_items = itemBox.get_children()

func _set_initial_menu_items() -> void:
	_update_health_upgrade()
	_update_stam_upgrade()
	_update_damage_upgrade()
	_update_speed_upgrade()

func _update_health_upgrade() -> void:
	var health_resource_string = _generate_health_resource_string_from_stat(stats.health_level)
	var health_item = load(health_resource_string)
	menu_items[ItemPositions.HEALTH_ITEM].set_menu_item(health_item)

func _update_stam_upgrade() -> void:
	var stam_resource_string = _generate_speed_resource_string_from_stat(stats.health_level)
	var stam_item = load(stam_resource_string)
	menu_items[ItemPositions.STAM_ITEM].set_menu_item(stam_item)

func _update_damage_upgrade() -> void:
	var damage_resource_string = _generate_damage_resource_string_from_stat(stats.health_level)
	var damage_item = load(damage_resource_string)
	menu_items[ItemPositions.DAMAGE_ITEM].set_menu_item(damage_item)

func _update_speed_upgrade() -> void:
	var speed_resource_string = _generate_speed_resource_string_from_stat(stats.health_level)
	var speed_item = load(speed_resource_string)
	menu_items[ItemPositions.SPEED_ITEM].set_menu_item(speed_item)

#gross function
#might rewrite but whatev
#updates menu item based on which one it is?
func _update_menu_item() -> void:
	match selectedItem: 
		0: 
			var weapon_resource_string = _generate_weapon_resource_string_from_stat(stats.weapon_level)
			var weapon_item = load(weapon_resource_string)
			menu_items[0].set_menu_item(weapon_item)
		1:
			var suit_resource_string = _generate_suit_resource_string_from_stat(stats.suit_level)
			var suit_item = load(suit_resource_string)
			menu_items[1].set_menu_item(suit_item)
	
#function to set description field
#could probably store button text as a resource but eh
func _set_description_field(item: menuItemResource) -> void:
	upgradeButton.visible = true
	if item.max_lvl:
		upgradeButton.visible = false
	elif stats.coins < item.price:
		upgradeButton.disabled = true
		_set_button_text("NOT ENOUGH COINS")
	else:
		upgradeButton.disabled = false
		_set_button_text("UPGRADE")
	_set_description_text(item.description)

#setter to set the button text
func _set_button_text(text: String) -> void:
	upgradeButtonLabel.text = text

#setter to set the description field text
func _set_description_text(text: String) -> void:
	description.text = text

#clears the description field
func _clear_description_field() -> void:
	upgradeButton.visible = false
	_clear_description_text()
	_clear_button_text()

#clears the button text
func _clear_button_text() -> void:
	upgradeButtonLabel.text = ""

#clears the description field text
func _clear_description_text() -> void:
	description.text = ""

#two jank functions that generate strings to the resources that need to be loaded
#for menu items
#opted for resources because that way there is saved data
func _generate_weapon_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Weapon" + str(upgrade_level) + ".tres"

func _generate_suit_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Suit" + str(upgrade_level) + ".tres"

func _generate_health_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Health Upgrades/Health" + str(upgrade_level) + ".tres"
	
func _generate_stam_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Stam Upgrades/Stam" + str(upgrade_level) + ".tres"
	
func _generate_damage_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Damage Upgrades/Damage" + str(upgrade_level) + ".tres"

func _generate_speed_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Speed Upgrades/Speed" + str(upgrade_level) + ".tres"

#pauses game
func _pause_game() -> void:
	get_tree().paused = true

#resumes game
func _resume_game() -> void:
	get_tree().paused = false
