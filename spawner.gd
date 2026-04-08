extends Node2D

@export var enemy_scene: PackedScene
@export var enemy_scene_big: PackedScene
@export var spawn_area: Rect2 # Define spawn area as a rectangle

func _ready() -> void:
	await get_tree().create_timer(3).timeout
	spawn_enemy()
	
func awai() -> void:
	await get_tree().create_timer(5).timeout
	spawn_enemy()

func spawn_enemy() -> void:
	# Instantiate the enemy
	var chance:float = randf_range(0,1)
	if chance > .3:
		var enemy = enemy_scene.instantiate()
		# Set random spawn position within the defined area
		var random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		var random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		enemy.position = Vector2(random_x, random_y)
		# Add enemy to the scene
		add_child(enemy)
	else:
		var enemy = enemy_scene_big.instantiate()
		# Set random spawn position within the defined area
		var random_x = randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x)
		var random_y = randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		enemy.position = Vector2(random_x, random_y)
		# Add enemy to the scene
		add_child(enemy)
	
	awai()
