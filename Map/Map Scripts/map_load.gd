extends TileMapLayer

func set_player_spawn(destination_door_tag: String):
	var player = get_node("/root/Main/Player")
	var spawn_marker_housing = get_node("doors/" + destination_door_tag)
	var spawn_marker = spawn_marker_housing.get_child(1)
	player.global_position = spawn_marker.global_position
