extends Resource
# This script is used for keeping track of player statistics.
# Health, Stamina, upgrades, etc.

#Any script that needs this resource can just preload it with the filepath
#Godot by default makes this a shared resource by anything in the scene tree
#(Any script that modifies the resource will modify the resource across all scripts accesssing it)
#The resource is found in res://PlayerControl/Resources/player_stats.tres

#All functions should send an emit_changed signal so other scripts can be notified when the resource is changed

class_name playerStats

@export var health: int
@export var stamina: int 
@export var coins: int
@export var weapon_level: int
@export var suit_level: int

#function used for coin testing input
func set_coins(coin_val: int) -> void:
	if coin_val > 999:
		coins = 999
	elif coin_val < 0:
		coins = 0
	else:
		coins = coin_val
	emit_changed()
