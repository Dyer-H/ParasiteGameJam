extends Node

# This script is used for keeping track of player statistics.
# Health, Stamina, upgrades, etc.

# Seems really similar to Kotlin tbh
# no C++ ;(

class_name playerStats

var health:int
var stamina:int

# No getter functions required since we can just use playerStats.health for fetching info
func _init(): 
	health=100
	stamina=100

func playerDamage(amount): # Using an amount so it should be easier to implement enemies doing different damage amounts
	health-=amount
	
func playerHeal(amount): # Same reasoning as damage function
	health+=amount
	
func reset(): # Reset function for spawning after death
	health=100
	stamina=100
