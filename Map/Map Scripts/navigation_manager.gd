extends Node

signal on_trigger_player_spawn(postion, direction)

var spawn_door_tag = null

"""func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"main":
			scene_to_load = scene_lobby
		"greenhall2":
			scene_to_load = scene_greenhall2
		"greenroom2":
			scene_to_load = scene_greenroom2
		"greenhall1":
			scene_to_load = scene_greenhall1
		"greenroom1_2door":
			scene_to_load = scene_greenroom1_2
		"greenhall1-2":
			scene_to_load = scene_greenhall12
		"greenroom3":
			scene_to_load = scene_greenroom3
		"greenhall1-3":
			scene_to_load = scene_greenhall13
		"greenroom1":
			scene_to_load = scene_greenroom1
		"redroom1":
			scene_to_load = scene_redroom1
		
		
		
		
		
	if scene_to_load != null:
		spawn_door_tag = destination_tag
		get_tree().call_deferred("change_scene_to_packed", scene_to_load)
"""
func go_to_scene(scene_path, door_tag):
	spawn_door_tag = door_tag
	get_tree().call_deferred("change_scene_to_file", scene_path)
		
func trigger_player_spawn(position:Vector2, direction: String):
	emit_signal("on_trigger_player_spawn", position, direction)
