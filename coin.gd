extends Node2D


func _on_pickup_range_body_entered(body: Node2D) -> void:
	if body.has_method("pickup"):
		body.pickup()
