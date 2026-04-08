extends CanvasLayer

var stats = preload("res://PlayerControl/Resources/player_stats.tres")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
	stats.set_health(stats.max_health)
	stats.set_coins(0)

func _on_button_2_pressed() -> void:
	get_tree().quit()
