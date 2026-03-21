extends ProgressBar

# Called when the node enters the scene tree for the first time.
var stats = preload("res://PlayerControl/Resources/player_stats.tres")

func _ready() -> void:
	var sb=StyleBoxFlat.new() # Create stylebox object
	add_theme_stylebox_override("fill",sb) # Add a fill override to the stylebox
	sb.bg_color=Color("59ff59") # Set fill color
	self.value = stats.stamina
	stats.changed.connect(_on_stats_changed)

func _on_stats_changed() -> void:
	self.value = stats.stamina
