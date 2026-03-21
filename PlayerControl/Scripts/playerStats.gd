extends Resource
# This script is used for keeping track of player statistics.
# Health, Stamina, upgrades, etc.

#Any script that needs this resource can just preload it with the filepath
#Godot by default makes this a shared resource by anything in the scene tree
#(Any script that modifies the resource will modify the resource across all scripts accesssing it)
#The resource is found in res://PlayerControl/Resources/player_stats.tres

class_name playerStats

@export var health: int
@export var stamina: int 
