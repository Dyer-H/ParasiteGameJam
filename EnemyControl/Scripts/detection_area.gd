extends Area2D

@onready var parent = $".."

# Detects when a body enters the area
func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name: # Detecting if body has that player function
		parent.player_in_area = true

# Same function as before but for body leaving the area
func _on_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		parent.player_in_area = false
