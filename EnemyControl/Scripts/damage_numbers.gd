extends Node

@onready var parent = $"."

func display_number(value:int, position:Vector2, is_critical:bool):
	var number = Label.new()
	number.top_level = true
	position += Vector2(randf_range(-7,7), randf_range(-5,1))
	number.global_position = position
	number.text = str(value)
	number.z_index = 5
	number.label_settings = LabelSettings.new()
	
	var color = "#FFF" # White
	if is_critical:
		color = "#B22" # Red
		
	number.label_settings.font_color = color
	number.label_settings.font_size = 16
	number.label_settings.outline_color = "#000" # Black
	number.label_settings.outline_size = 2
	
	call_deferred("add_child", number)
	
	await number.resized
	number.pivot_offset = number.size / 2
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(
		number, "position:y", number.position.y - 12, 0.25
	).set_ease(Tween.EASE_OUT)
	tween.tween_property(
		number, "position:y", number.position.y, 0.5
	).set_ease(Tween.EASE_IN).set_delay(0.25)
	tween.tween_property(
		number, "scale", Vector2.ZERO, 0.25
	).set_ease(Tween.EASE_IN).set_delay(0.5)
	
	await tween.finished
	number.queue_free()
