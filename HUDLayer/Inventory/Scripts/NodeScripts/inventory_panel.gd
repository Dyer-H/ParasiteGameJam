extends Panel

class_name InventoryPanel

@onready var background: TextureRect = $background
@onready var item_display: TextureRect = $item_display
var inventoryItem: InventoryItem = null

#function gets an inventory item at a slot and returns it to then be passed to _drop_data
#if there is no inventory item at that slot, do nothing
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !inventoryItem:
		return
	var preview = Control.new()
	var preview_data = duplicate()
	preview.add_child(preview_data)
	preview_data.position = Vector2.ZERO - _at_position
	set_drag_preview(preview)
	return self

#function asks whether or not the slot is available to drop data into
#we can just say that this is always yes
#could add custom behavior for custom slots if wanted
func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return true
#function sets the item data at the position it was dropped in
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	setItem(data.inventoryItem.duplicate())
	data.clearItem()

#function sets the panel size in pixels
func setPanelSize(p_size: int) -> void:
	self.set_custom_minimum_size(Vector2(p_size, p_size))
	background.set_custom_minimum_size(Vector2(p_size, p_size))
	item_display.set_custom_minimum_size(Vector2(p_size, p_size))
#function sets the item for this panel instance
func setItem(item: InventoryItem) -> void:
	inventoryItem = item
	setItemTexture()
#sets the background of a panel
func setBackground(textureString: String) -> void:
	background.texture = load(textureString)
#function sets the texture of the item based on item information
func setItemTexture() -> void:
	if !inventoryItem:
		return
	item_display.texture = inventoryItem.item_texture
	
#function just sets both of these things to null
#godot apparently has garbage collection but if this becomes an issue please revisit
func clearItem() -> void:
	item_display.texture = null
	inventoryItem = null
