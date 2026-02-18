#SCRIPT TIED TO INVENTORY UI CONTROL NODE
#CONTAINS INVENTORY LOGIC
extends Control

@onready var inventoryPanels: Array = $CenterContainer/InventoryBackground/MarginContainer/GridContainer.get_children()
@onready var wood = preload("res://Inventory/ResourceInstances/wood.tres")

#when it loads it shouldn't be visible
func _ready() -> void:
	self.visible = false
	addWood()

#when the "Toggle Inventory" button is pressed (mapped to i currently) -> show inventory
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Inventory"):
		if self.visible == true:
			self.visible = false
			return
		self.visible = true
		
func addWood() -> void:
	inventoryPanels[0].setItem(wood)
