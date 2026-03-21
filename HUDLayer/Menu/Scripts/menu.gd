extends Control

#this should always be selectable menu items
@onready var menu_items = $TextureRect/GridContainer.get_children()
@onready var description = $TextureRect/DescriptionBackground/MarginContainer/ItemDescription

var stats = preload("res://PlayerControl/Resources/player_stats.tres")
var isItemSelected = false
var selectedItem = 0

func _ready() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	_populate_menu_items()
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Menu"):
		if self.visible == true:
			self.visible = false
			_resume_game()
			return
		self.visible = true
		_pause_game()

func _on_item_clicked(event, menu_item) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index != MOUSE_BUTTON_LEFT:
			return
		var pos = menu_items.find(menu_item)
		if !isItemSelected:
			menu_item.toggle_selection()
			_set_description(menu_item.item.description)
			selectedItem = pos
			isItemSelected = true
			return
		if pos == selectedItem:
			menu_item.toggle_selection()
			_clear_description()
			isItemSelected = false
			return
		menu_items[selectedItem].toggle_selection()
		menu_item.toggle_selection()
		_set_description(menu_item.item.description)
		selectedItem = pos
		return

func _populate_menu_items() -> void:
	var weapon_resource_string = _generate_weapon_resource_string_from_stat(stats.weapon_level)
	var suit_resource_string = _generate_suit_resource_string_from_stat(stats.suit_level)
	var weapon_item = load(weapon_resource_string)
	var suit_item = load(suit_resource_string)
	menu_items[0].set_menu_item(weapon_item)
	menu_items[1].set_menu_item(suit_item)
	for menu_item in menu_items:
		menu_item.gui_input.connect(_on_item_clicked.bind(menu_item))

func _set_description(text: String) -> void:
	description.text = text
	
func _clear_description() -> void:
	description.text = ""

func _generate_weapon_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Weapon" + str(upgrade_level) + ".tres"

func _generate_suit_resource_string_from_stat(upgrade_level: int) -> String:
	return "res://HUDLayer/Menu/Resources/Suit" + str(upgrade_level) + ".tres"

func _pause_game() -> void:
	get_tree().paused = true

func _resume_game() -> void:
	get_tree().paused = false
