extends Panel

@onready var item_display: TextureRect = $item_display
var inventoryItem: InventoryItem = null

#############################################
########### DRAG AND DROP LOGIC #############
#############################################

#function gets an inventory item at a slot and returns it to then be passed to _drop_data
#if there is no inventory item at that slot, do nothing
func _get_drag_data(_at_position: Vector2) -> Variant:
	if !inventoryItem:
		return
	var preview = duplicate()
	set_drag_preview(preview)
	return self

#function asks whether or not the slot is available to drop data into
#we can just say that this is always yes
#could add custom behavior for custom slots if wanted
func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	
#function sets the item data at the position it was dropped in
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	setItem(data.inventoryItem.duplicate())
	data.clearItem()

#############################################
############### DATA LOGIC ##################
#############################################

#function sets the item for this panel instance
func setItem(item: InventoryItem):
	inventoryItem = item
	setTexture()

#function sets the texture of the textureRect based on item information
func setTexture():
	if !inventoryItem:
		return
	item_display.texture = inventoryItem.item_texture
	
#function just sets both of these things to null
#godot apparently has garbage collection but if this becomes an issue please revisit
func clearItem():
	item_display.texture = null
	inventoryItem = null
