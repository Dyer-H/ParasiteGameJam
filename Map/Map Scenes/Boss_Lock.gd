extends CollisionShape2D

@onready var boss = $"../../BOSS"

func _process(_delta: float) -> void:
	if boss == null:
		disabled = true
