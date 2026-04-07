extends ProgressBar

var stats = preload("res://PlayerControl/Resources/player_stats.tres")
var local_bullets: int
var fill_stylebox: StyleBoxFlat

func _ready():
	self.value = stats.curr_bullets
	fill_stylebox = get_theme_stylebox("fill")
	stats.changed.connect(_on_stats_changed)

func _process(_delta):
	if stats.curr_bullets == 0:
		var old_stylebox = fill_stylebox.duplicate()
		var new_stylebox = fill_stylebox.duplicate()
		new_stylebox.bg_color = Color(1.842, 0.016, 0.016, 1.0)
		add_theme_stylebox_override("fill", new_stylebox)
		local_bullets = 0
		while local_bullets < 8:
			local_bullets += 1
			await get_tree().create_timer(0.5).timeout
			self.value = local_bullets
		stats.curr_bullets = 8
		add_theme_stylebox_override("fill", old_stylebox)

func _on_stats_changed():
	self.value = stats.curr_bullets
