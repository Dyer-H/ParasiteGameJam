extends Node2D

func _ready():
	if NavigationManager.spawn_door_tag != null:
		_spawn_player(NavigationManager.spawn_door_tag)
		
		
func _spawn_player(destination_tag: String):
	var doors = get_tree().get_nodes_in_group("doors")
	for d in doors:
		if d.destination_door_tag == destination_tag:
			var spawn_pos = d.get_node("Spawn").global_position
			var direction = d.spawn_direction
			NavigationManager.trigger_player_spawn(spawn_pos, direction)
