extends ProgressBar

# Called when the node enters the scene tree for the first time.
var stats = preload("res://PlayerControl/Resources/player_stats.tres")

func _ready() -> void:
	var sb=StyleBoxFlat.new() # Create stylebox object
	add_theme_stylebox_override("fill",sb) # Add a fill override to the stylebox
	sb.bg_color=Color("ff596f") # Set fill color
	self.value = stats.health
	stats.changed.connect(_on_stats_changed)

func _on_stats_changed(health: int = stats.health) -> void:
	self.value = stats.health
	self.max_value = stats.max_health
	stats.health = health
	if stats.health <= 0:
		die()
		
func die():
	stats.set_coins(0)
	
	get_tree().change_scene_to_file("res://HUDLayer/Death/game_over.tscn")
