extends ProgressBar

# Called when the node enters the scene tree for the first time.
var stats=playerStats.new()

func _ready() -> void:
	var sb=StyleBoxFlat.new() # Create stylebox object
	add_theme_stylebox_override("fill",sb) # Add a fill override to the stylebox
	sb.bg_color=Color("59ff59") # Set fill color
	stats.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.value=stats.stamina # Set own value to stamina stat
