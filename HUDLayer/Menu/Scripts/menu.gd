extends Control

#this should always be selectable menu items
@onready var menu_items = $TextureRect/GridContainer.get_children()
@onready var description = $TextureRect/DescriptionBackground/MarginContainer/ItemDescription
@onready var upgradeButton = $TextureRect/DescriptionBackground/UpgradeButton
@onready var upgradeButtonLabel = $TextureRect/DescriptionBackground/UpgradeButton/UpgradeButtonLabel


var stats = preload("res://PlayerControl/Resources/player_stats.tres")
var isItemSelected = false
var selectedItem = 0

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

#populates menu items based on stat level
func _populate_menu_items() -> void:
	var weapon_resource_string = _generate_weapon_resource_string_from_stat(stats.weapon_level)
	var suit_resource_string = _generate_suit_resource_string_from_stat(stats.suit_level)
	var weapon_item = load(weapon_resource_string)
	var suit_item = load(suit_resource_string)
	menu_items[0].set_menu_item(weapon_item)
	menu_items[1].set_menu_item(suit_item)
	for menu_item in menu_items:
		var button = menu_item.get_node("BorderMargin/Button")
		button.pressed.connect(_on_item_clicked.bind(menu_item))
	upgradeButton.pressed.connect(_on_upgrade_button_clicked)	

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

#pauses game
func _pause_game() -> void:
	get_tree().paused = true

#resumes game
func _resume_game() -> void:
	get_tree().paused = false
