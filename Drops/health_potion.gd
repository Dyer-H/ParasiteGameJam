extends Node2D

func heal() -> int:
	self.queue_free()
	return randi_range(15,35)
