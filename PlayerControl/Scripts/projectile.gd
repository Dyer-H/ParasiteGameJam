extends Area2D

const bullet_speed: int = 3000
var stats = preload("res://PlayerControl/Resources/player_stats.tres")

func _ready():
	await get_tree().create_timer(stats.bullet_range).timeout
	free_node()
	
func _process(delta: float) -> void:
	position += transform.x * delta * bullet_speed

func get_damage() -> int:
	return stats.gun_damage

func get_crit() -> float:
	return stats.crit_chance
	
func get_dir() -> Vector2:
	return global_position

func free_node():
	self.queue_free()

func _on_body_entered(body: Node2D) -> void:
	if "Walls" in body.name:
		free_node()
