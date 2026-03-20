extends Area2D

const speed=3000

func _process(delta: float) -> void:
	position+=transform.x*(delta*speed)
