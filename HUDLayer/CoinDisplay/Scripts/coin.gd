extends Node

@onready var coin_number = $CoinNumber

var stats = preload("res://PlayerControl/Resources/player_stats.tres")

#loads value of resource's coin value by default
#connects the stats changing to custom function that just changes label text
func _ready() -> void:
	coin_number.text = str(stats.coins)
	stats.changed.connect(_on_resource_changed)

#changes label text to new changed coin value
func _on_resource_changed() -> void:
	coin_number.text = str(stats.coins)
