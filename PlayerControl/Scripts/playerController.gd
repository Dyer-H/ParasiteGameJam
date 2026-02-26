extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 80.0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("move_up") && Input.is_action_pressed("move_right"):
		animated_sprite.play("walk_up_right")
	elif Input.is_action_pressed("move_up") && Input.is_action_pressed("move_left"):
		animated_sprite.play("walk_up_left")
	elif Input.is_action_pressed("move_down") && Input.is_action_pressed("move_right"):
		animated_sprite.play("walk_down_right")
	elif Input.is_action_pressed("move_down") && Input.is_action_pressed("move_left"):
		animated_sprite.play("walk_down_left")
	elif Input.is_action_pressed("move_up"):
		animated_sprite.play("walk_up")
	elif Input.is_action_pressed("move_down"):
		animated_sprite.play("walk_down")
	elif Input.is_action_pressed("move_right"):
		animated_sprite.play("walk_right")
	elif Input.is_action_pressed("move_left"):
		animated_sprite.play("walk_left")
	else:
		animated_sprite.stop()

func _physics_process(_delta: float) -> void:
	get_input()
	
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	move_and_slide()
