extends Node

@onready var coin_number = $CoinNumber

var stats = preload("res://PlayerControl/Resources/player_stats.tres")

func _ready() -> void:
	coin_number.text = str(stats.coins)
	stats.changed.connect(_on_resource_changed)
	
func _on_resource_changed() -> void:
	coin_number.text = str(stats.coins)
