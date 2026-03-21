extends TextureRect

@onready var selection: TextureRect = $BorderMargin/Selection
@onready var background: TextureRect = $BorderMargin/Selection/SelectionMargin/Background
@onready var itemLabel: Label = $"BorderMargin/Selection/SelectionMargin/Background/Item Label"
@onready var itemPrice: Label = $"BorderMargin/Selection/SelectionMargin/Background/Price Label"

var selection_texture = preload("res://HUDLayer/Menu/GUIResources/white_background.jpg")
var isSelected = false
var item: menuItemResource

func toggle_selection() -> void:
	if isSelected:
		selection.texture = background.texture
		isSelected = false
		return
	selection.texture = selection_texture
	isSelected = true

func set_menu_item(menu_item: menuItemResource) -> void:
	item = menu_item
	_populate_from_resource()

func _populate_from_resource() -> void:
	itemLabel.text = item.name
	itemPrice.text = str(item.price)
