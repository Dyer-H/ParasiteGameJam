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

@export var max_health: int
@export var max_stamina: int
@export var gun_damage: int

@export var bullet_range: float
@export var crit_chance: float
@export var dash_regen: float
@export var player_speed: int

@export var coins: int

@export var health_level: int
@export var stam_level: int
@export var damage_level: int
@export var range_level: int
@export var crit_level: int
@export var dash_level: int
@export var speed_level: int

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

#function used to subtract from health
#cannot go below 0
func take_damage(damage: int) -> void:
	var new_health = health - damage
	if new_health < 0:
		health = 0
	else:
		health = new_health
	emit_changed()

func set_max_health(new_max_health: int) -> void:
	max_health = new_max_health
	emit_changed()

func set_bullet_range(new_range: float) -> void:
	bullet_range = new_range
	emit_changed()
	
func set_crit_chance(new_crit_chance: float) -> void:
	crit_chance = new_crit_chance
	emit_changed()
	
func set_dash_regen(new_dash_regen: float) -> void:
	dash_regen = new_dash_regen
	emit_changed()
	
func set_player_speed(new_player_speed: int) -> void:
	player_speed = new_player_speed
	emit_changed()

func increment_health_level() -> void:
	health_level += 1

func increment_stam_level() -> void:
	stam_level += 1
	
func increment_damage_level() -> void:
	damage_level += 1

func increment_range_level() -> void:
	range_level += 1
	
func increment_crit_level() -> void:
	crit_level += 1
	
func increment_dash_level() -> void:
	dash_level += 1
	
func increment_speed_level() -> void:
	speed_level += 1
	
func change_stamina(val)->void:
	self.value+=val
	stamina-=val
