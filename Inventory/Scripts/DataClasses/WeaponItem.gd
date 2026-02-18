#special type of inventory item (weapon)
#made it its own class so it can have different member variables
#and can be distinguished to prevent stacking (if we ever need that functionality)
extends InventoryItem
class_name WeaponItem

@export var weapon_damage: int
