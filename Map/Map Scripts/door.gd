extends Area2D

#class_name Door

#@export var destination_level_tag: String
@export_file("*.tscn") var destination_scene: String
@export var destination_door_tag: String
@export var spawn_direction : String = "down"

@onready var spawn = $Spawn
var map_node: Node2D

func _ready():
	map_node = get_node("/root/Main/MapNode")

func _on_body_entered(body) -> void:
	if body is Player:
		move_to_scene()

func move_to_scene() -> void:
	var map = map_node.get_child(0)
	map.queue_free()
	var new_map = load(destination_scene)
	new_map = new_map.instantiate()
	map_node.add_child(new_map)
	new_map.set_player_spawn(destination_door_tag)
