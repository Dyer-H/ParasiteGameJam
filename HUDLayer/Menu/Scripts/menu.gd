extends Control

func _ready() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Menu"):
		if self.visible == true:
			self.visible = false
			_resume_game()
			return
		self.visible = true
		_pause_game()

func _pause_game() -> void:
	get_tree().paused = true
	
func _resume_game() -> void:
	get_tree().paused = false
