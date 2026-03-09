#SCRIPT TIED TO INVENTORY UI CONTROL NODE
#CONTAINS INVENTORY LOGIC
extends Control
var stats=playerStats.new()
#hyperparameters (control margins and columns and such)
@export var margin_size_margin_container: int = 10 #number of pixels for margin around all cells
@export var margin_size_grid_container: int = 5 #number of pixels for margin between cells
@export var num_columns_grid_container: int = 4 #number of grid items per row (please don't set to 0)
@export var num_total_slots: int = stats.slots #number of total inventory slots (please don't set to 0)
@export var size_per_slot: int = 80 #number of pixels for SQUARE inventory slot (width) (please don't set to 0)

#UI Elements
@onready var inventoryBackground: TextureRect = $CenterContainer/InventoryBackground
@onready var marginContainer: MarginContainer = $CenterContainer/InwdventoryBackground/MarginContainer
@onready var gridContainer: GridContainer = $CenterContainer/InventoryBackground/MarginContainer/GridContainer
const wood: Resource = preload("res://HUDLayer/Inventory/ResourceInstances/wood.tres")
const inventoryPanel = preload("res://HUDLayer/Inventory/Scenes/InventoryPanel.tscn")

#global variables to keep track of so every function doesn't need it as a parameter
#these DO NOT need to be changed, program handles all logic to change
var num_rows_grid_container: int = 0
var total_grid_container_size: Dictionary = {"width": 0, "height": 0}
var inventoryPanels: Array

#function runs when everything loads
func _ready() -> void:
	updateInventoryUI()
	self.visible = false
	addWood()

#when the "Toggle Inventory" button is pressed (mapped to i currently) -> show inventory
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Inventory"):
		if self.visible == true:
			self.visible = false
			return
		self.visible = true


#sets the size of the whole inventory based on all inventory parameters
func updateInventoryUI() -> void:
	setNumColumns()
	setNumRows(doRoundUpDivision(num_total_slots, num_columns_grid_container))
	var margin_dict: Dictionary = setInternalMargins()
	setExternalMargins() # FUNCTION HAVING TROUBLE PLS CHECK IT OUT
	setGridContainerSize(margin_dict)
	setInventoryBackgroundSize()
	createInventoryPanels()


#sets the global variable num_rows_grid_container
func setNumRows(rows: int) -> void:
	num_rows_grid_container = rows
#sets the number of columns for the grid container
func setNumColumns() -> void:
	gridContainer.columns = num_columns_grid_container
#admittedly, below code is super ugly, not sure where to refactor (combinatorial problem)
#sets the internal spacing between cells in the grid container
#returns a dictionary telling whether or not v and h separation were set
func setInternalMargins() -> Dictionary:
	if num_rows_grid_container == 1 && num_columns_grid_container == 1:
		gridContainer.add_theme_constant_override("v_separation", 0)
		gridContainer.add_theme_constant_override("h_separation", 0)
		return {"v_separation": false, "h_separation": false}
	elif num_rows_grid_container == 1:
		gridContainer.add_theme_constant_override("v_separation", 0)
		gridContainer.add_theme_constant_override("h_separation", margin_size_grid_container)
		return {"v_separation": false, "h_separation": true}
	elif num_columns_grid_container == 1:
		gridContainer.add_theme_constant_override("v_separation", margin_size_grid_container) 
		gridContainer.add_theme_constant_override("h_separation", 0)
		return {"v_separation": true, "h_separation": false}
	else:
		gridContainer.add_theme_constant_override("v_separation", margin_size_grid_container) 
		gridContainer.add_theme_constant_override("h_separation", margin_size_grid_container)
		return {"v_separation": true, "h_separation": true}
#sets the margin container margins (spacing around cells)
func setExternalMargins() -> void:
	marginContainer.add_theme_constant_override("margin_left", margin_size_margin_container)
	marginContainer.add_theme_constant_override("margin_top", margin_size_margin_container)
	marginContainer.add_theme_constant_override("margin_right", margin_size_margin_container)
	marginContainer.add_theme_constant_override("margin_bottom", margin_size_margin_container)
#sets the grid container size based on a dictionary returned by the set internal margins function
#has the same refactoring problem as set internal margins
#doesn't actually set any UI elements, just data to use for other UI elements
func setGridContainerSize(margin_dict: Dictionary) -> void:
	if margin_dict["v_separation"] == false && margin_dict["h_separation"] == false:
		total_grid_container_size["width"] = size_per_slot
		total_grid_container_size["height"] = size_per_slot
	elif margin_dict["v_separation"] == false && margin_dict["h_separation"] == true:
		total_grid_container_size["width"] = size_per_slot * num_columns_grid_container + margin_size_grid_container * (num_columns_grid_container - 1)
		total_grid_container_size["height"] = size_per_slot
	elif margin_dict["v_separation"] == true && margin_dict["h_separation"] == false:
		total_grid_container_size["width"] = size_per_slot
		total_grid_container_size["height"] = size_per_slot * num_rows_grid_container + margin_size_grid_container * (num_rows_grid_container - 1)
	else: 
		total_grid_container_size["width"] = size_per_slot * num_columns_grid_container + margin_size_grid_container * (num_columns_grid_container - 1)
		total_grid_container_size["height"] = size_per_slot * num_rows_grid_container + margin_size_grid_container * (num_rows_grid_container - 1)
#sets the size of the inventory background UI element
func setInventoryBackgroundSize() -> void:
	var width: int = total_grid_container_size["width"] + 2 * margin_size_margin_container
	var height: int = total_grid_container_size["height"] + 2 * margin_size_margin_container
	inventoryBackground.set_custom_minimum_size(Vector2(width, height))

#essentially does what ceil(a) does in most languages after division
func doRoundUpDivision(numerator:int, denominator:int) -> int:
	if numerator % denominator == 0:
		@warning_ignore("integer_division")
		return numerator / denominator
	@warning_ignore("integer_division")
	return numerator / denominator + 1
#creates the appropriate number of inventory panels in the grid container based on total slots
func createInventoryPanels() -> void:
	for i in range(num_total_slots):
		var new_inventory_panel: InventoryPanel = inventoryPanel.instantiate()
		gridContainer.add_child(new_inventory_panel)
		new_inventory_panel.setPanelSize(size_per_slot)
	inventoryPanels = gridContainer.get_children()
#function for testing
func addWood() -> void:
	inventoryPanels[0].setItem(wood)
