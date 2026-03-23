extends TextureRect

@onready var button: Button = $BorderMargin/Button
@onready var itemLabel: Label = $"BorderMargin/Button/Item Label"
@onready var itemPrice: Label = $"BorderMargin/Button/Price Label"

var selection_texture = preload("res://HUDLayer/Menu/GUIResources/white_background.jpg")
var isSelected = false
var item: menuItemResource

func toggle_selection() -> void:
	var stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	var stylebox_hover = button.get_theme_stylebox("hover").duplicate()
	if isSelected:
		stylebox_normal.set_border_width_all(0)
		stylebox_hover.set_border_width_all(0)
		button.add_theme_stylebox_override("normal", stylebox_normal)
		button.add_theme_stylebox_override("hover", stylebox_hover)
		isSelected = false
		return
	stylebox_normal.set_border_width_all(5)
	stylebox_hover.set_border_width_all(5)
	button.add_theme_stylebox_override("normal", stylebox_normal)
	button.add_theme_stylebox_override("hover", stylebox_hover)
	isSelected = true

func set_menu_item(menu_item: menuItemResource) -> void:
	item = menu_item
	_populate_from_resource()

func _populate_from_resource() -> void:
	itemLabel.text = item.name
	itemPrice.text = str(item.price)
