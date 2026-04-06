extends Control

@onready var description = $TextureRect/DescriptionBackground/MarginContainer/ItemDescription
@onready var upgradeButton = $TextureRect/DescriptionBackground/UpgradeButton
@onready var upgradeButtonLabel = $TextureRect/DescriptionBackground/UpgradeButton/UpgradeButtonLabel
@onready var itemBox = $TextureRect/ScrollContainer/GridContainer

const selectable_menu_item = preload("res://HUDLayer/Menu/Scenes/selectable_menu_item.tscn")
var stats = preload("res://PlayerControl/Resources/player_stats.tres")
var isItemSelected: bool = false
var selectedItem = 0

#Can rearrange these
#Will change positions of menu items
#Do not change names 
enum ItemPositions{
	HEALTH_ITEM,
	STAM_ITEM,
	DAMAGE_ITEM,
	BULLET_ITEM,
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

#this happens every time a menu item is clicked
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
		ItemPositions.HEALTH_ITEM:
			var max_health = current_selection.item.health
			stats.set_max_health(max_health)
			stats.increment_health_level()
			_update_health_upgrade()
		ItemPositions.STAM_ITEM:
			var max_stam = current_selection.item.stamina
			stats.increment_stam_level()
			stats.set_max_stamina(max_stam)
			_update_stam_upgrade()
		ItemPositions.DAMAGE_ITEM:
			var new_damage = current_selection.item.damage
			stats.gun_damage = new_damage
			stats.increment_damage_level()
			_update_damage_upgrade()
		ItemPositions.BULLET_ITEM:
			var new_bullets = current_selection.item.num_bullets
			stats.num_bullets = new_bullets
			stats.increment_bullet_level()
			_update_bullet_upgrade()
		ItemPositions.RANGE_ITEM:
			var new_range = current_selection.item.bullet_range
			stats.bullet_range = new_range
			stats.increment_range_level()
			_update_range_upgrade()
		ItemPositions.CRIT_ITEM:
			var new_crit = current_selection.item.crit_chance
			stats.crit_chance = new_crit
			stats.increment_crit_level()
			_update_crit_upgrade()
		ItemPositions.DASH_ITEM:
			var new_dash = current_selection.item.dash_regen
			stats.dash_regen = new_dash
			stats.increment_dash_level()
			_update_dash_upgrade()
		ItemPositions.SPEED_ITEM:
			var new_speed = current_selection.item.player_speed
			stats.player_speed = new_speed
			stats.increment_speed_level()
			_update_speed_upgrade()
	current_selection.toggle_selection()
	_clear_description_field()
	isItemSelected = false

#populates menu items at ready
func _populate_menu_items() -> void:
	_create_selectable_menu_items()
	_set_initial_menu_items()
	_set_initial_menu_item_listeners()

#creates number of selectable menu items based on the enum at top
func _create_selectable_menu_items() -> void:
	var num_item_positions = ItemPositions.keys().size()
	for i in range(num_item_positions):
		var new_selectable_menu_item = selectable_menu_item.instantiate()
		new_selectable_menu_item.custom_minimum_size = Vector2(1000, 122) #1000 is number from scroll container size, 122 is good looking height
		itemBox.add_child(new_selectable_menu_item)
	menu_items = itemBox.get_children()

#calls all update functions to set the values in the selectable menu items
func _set_initial_menu_items() -> void:
	_update_health_upgrade()
	_update_stam_upgrade()
	_update_damage_upgrade()
	_update_bullet_upgrade()
	_update_range_upgrade()
	_update_crit_upgrade()
	_update_dash_upgrade() 
	_update_speed_upgrade()
	
func _set_initial_menu_item_listeners() -> void: 
	for menu_item in menu_items:
		var button = menu_item.get_node("BorderMargin/Button")
		button.pressed.connect(_on_item_clicked.bind(menu_item))
	upgradeButton.pressed.connect(_on_upgrade_button_clicked)

func _update_health_upgrade() -> void:
	var health_resource_string = _generate_health_resource_string_from_stat(stats.health_level)
	var health_item = load(health_resource_string)
	menu_items[ItemPositions.HEALTH_ITEM].set_menu_item(health_item)

func _update_stam_upgrade() -> void:
	var stam_resource_string = _generate_stam_resource_string_from_stat(stats.stam_level)
	var stam_item = load(stam_resource_string)
	menu_items[ItemPositions.STAM_ITEM].set_menu_item(stam_item)

func _update_damage_upgrade() -> void:
	var damage_resource_string = _generate_damage_resource_string_from_stat(stats.damage_level)
	var damage_item = load(damage_resource_string)
	menu_items[ItemPositions.DAMAGE_ITEM].set_menu_item(damage_item)

func _update_bullet_upgrade() -> void:
	var bullet_resource_string = _generate_bullet_resource_string_from_stat(stats.bullet_level)
	var bullet_item = load(bullet_resource_string)
	menu_items[ItemPositions.BULLET_ITEM].set_menu_item(bullet_item)

func _update_range_upgrade() -> void:
	var range_resource_string = _generate_range_resource_string_from_stat(stats.range_level)
	var range_item = load(range_resource_string)
	menu_items[ItemPositions.RANGE_ITEM].set_menu_item(range_item)
	
func _update_crit_upgrade() -> void:
	var crit_resource_string = _generate_crit_resource_string_from_stat(stats.crit_level)
	var crit_item = load(crit_resource_string)
	menu_items[ItemPositions.CRIT_ITEM].set_menu_item(crit_item)
	
func _update_dash_upgrade() -> void:
	var dash_resource_string = _generate_dash_resource_string_from_stat(stats.dash_level)
	var dash_item = load(dash_resource_string)
	menu_items[ItemPositions.DASH_ITEM].set_menu_item(dash_item)

func _update_speed_upgrade() -> void:
	var speed_resource_string = _generate_speed_resource_string_from_stat(stats.speed_level)
	var speed_item = load(speed_resource_string)
	menu_items[ItemPositions.SPEED_ITEM].set_menu_item(speed_item)

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

#functions that generate strings to the resources that need to be loaded
#for menu items
#opted for resources because that way there is saved data
func _generate_health_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Health Upgrades/Health" + str(upgrade_level) + ".tres"
	
func _generate_stam_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Stam Upgrades/Stam" + str(upgrade_level) + ".tres"
	
func _generate_damage_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Damage Upgrades/Damage" + str(upgrade_level) + ".tres"

func _generate_bullet_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Bullet Upgrades/Bullet" + str(upgrade_level) + ".tres"

func _generate_range_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Range Upgrades/Range" + str(upgrade_level) + ".tres"

func _generate_crit_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Crit Upgrades/Crit" + str(upgrade_level) + ".tres"

func _generate_dash_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Dash Upgrades/Dash" + str(upgrade_level) + ".tres"

func _generate_speed_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Speed Upgrades/Speed" + str(upgrade_level) + ".tres"

#pauses game
func _pause_game() -> void:
	get_tree().paused = true

#resumes game
func _resume_game() -> void:
	get_tree().paused = false
