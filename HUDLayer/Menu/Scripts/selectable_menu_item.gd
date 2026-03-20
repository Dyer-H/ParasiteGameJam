#Please don't mess with anything in the selectable_menu_item scene via the inspector dock
#If anything needs to be changed, do it via the code provided below
#You can change the instatiated scene in the menu scene via the exported variables though

extends TextureRect

#some reasonable defaults I came up with for the following parameters
#welcome to change any of these
@export var menu_item_width = 1000
@export var menu_item_height = 122
@export var border_margin_size = 3
@export var selection_margin_size = 5

@onready var borderMargin: MarginContainer = $BorderMargin
@onready var selection: TextureRect = $BorderMargin/Selection
@onready var selectionMargin: MarginContainer = $BorderMargin/Selection/SelectionMargin
@onready var background: TextureRect = $BorderMargin/Selection/SelectionMargin/Background

func _set_initial_sizes():
	print("nothing")

func update_menu_item_size(rectangle_size: Vector2):
	self.size = rectangle_size
