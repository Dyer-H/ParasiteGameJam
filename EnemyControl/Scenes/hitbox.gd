extends Area2D

@onready var parent = $".."

func _on_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		parent.player_hit = true

func _on_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		parent.player_hit = false
		parent.hit_cooldown = 0

func _on_area_entered(area: Area2D) -> void:
	if area.has_method("get_damage"):
		var damage = area.get_damage()
		var crit_chance = area.get_crit()
		var direction = area.get_dir()
		parent.take_damage(damage, crit_chance, direction)
	if area.has_method("free_node"):
		area.free_node()
