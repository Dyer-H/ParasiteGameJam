extends Node2D

@onready var _animated_sprite = $AnimatedSprite2D

func _ready() -> void:
	_animated_sprite.play("Coin_Spin")

func pickup_coin():
	self.queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	_animated_sprite.play("Coin_Spin")
