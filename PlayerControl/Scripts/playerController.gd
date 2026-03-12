extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var healthbar = $"../HUD Layer/HP_STAM/HealthBar"
const SPEED = 80.0

#literally just animation code -> no need to touch
#unless of course animation also needs to be tied to delta param
#which it probably will ngl
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

#this function will have to pass delta to the next eventually
#again because we don't want movement tied to framerate
func _physics_process(_delta: float) -> void:
	get_input()

#gets vector based on values set in project settings
#can modify the speed using global parameter or in project settings
#(probably should modify the one here (the global param))
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_direction * SPEED
	move_and_slide()

# Called when taking damage
# Can be referrenced in other scripts in node2D passed
func take_damage(damage:int): 
	healthbar.change_health(damage)
