extends Area2D

#class_name Door

#@export var destination_level_tag: String
@export_file("*.tscn") var destination_scene: String
@export var destination_door_tag: String
@export var spawn_direction : String = "down"


@onready var spawn = $Spawn



func _on_body_entered(body) -> void:
	if body.is_in_group("player"):
		NavigationManager.go_to_scene(destination_scene, destination_door_tag)
