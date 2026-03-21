extends Control

#this is primarily used for testing
#no error checking for bad input
#no error checking for menu being open and pausing and resuming the game correctly
#use when menu is not open

@onready var textbox: LineEdit = $LineEdit

var stats = preload("res://PlayerControl/Resources/player_stats.tres")

#sets the visibility to false
#also connects the text_submitted signal from the line edit to custom function defined below
func _ready() -> void:
	self.visible = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	textbox.text_submitted.connect(_on_text_submitted)
	
#listens for input action to toggle visibility
#also pauses and resumes game as necessary
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Toggle Dev Coin"):
		if self.visible == true:
			self.visible = false
			_resume_game()
			return
		self.visible = true
		_pause_game()

#sets the coin value from inputted text
func _on_text_submitted(new_text) -> void:
	var coin_val = new_text.to_int()
	stats.set_coins(coin_val)
	textbox.clear()
	self.visible = false
	_resume_game()

func _pause_game() -> void:
	get_tree().paused = true
	
func _resume_game() -> void:
	get_tree().paused = false
