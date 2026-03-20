extends ProgressBar

# Called when the node enters the scene tree for the first time.
var stats=player.new()

func _ready() -> void:
	var sb=StyleBoxFlat.new() # Create stylebox object
	add_theme_stylebox_override("fill",sb) # Add a fill override to the stylebox
	sb.bg_color=Color("ff596f") # Set fill color
	stats.reset()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.value=stats.health # Set own value to health stat
	

func change_health(damage: int):
	stats.health -= damage
	print(stats.health)
