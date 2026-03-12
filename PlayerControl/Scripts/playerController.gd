extends CharacterBody2D

@export var projectile:PackedScene
@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 80.0

#this function will have to pass delta to the next eventually
#again because we don't want movement tied to framerate
func _physics_process(_delta: float) -> void:
	get_input()
	if(Input.is_action_just_pressed("Shoot")):
		var dev=-15+randi_range(-5,5) # This is the starting deviation for the shot (degrees off from normal
		for i in range(7): # range(number of pellets to generate)
			var newProjectile=projectile.instantiate() as Node2D
			get_tree().current_scene.add_child(newProjectile)
			newProjectile.global_position=global_position
			newProjectile.look_at(get_global_mouse_position())
			newProjectile.rotation_degrees+=(dev+(i*5-randi_range(-2,2))) # dev+(spread of each pellet)

#gets vector based on values set in project settings
#discretizes then moves that direction
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var discretized_direction = Globals.discretize_movement_direction(input_direction.normalized())
	play_animation(discretized_direction)
	velocity = discretized_direction * SPEED
	move_and_slide()
	
#expects a discretized vector (defined in global class)
func play_animation(direction: Vector2):	
	match direction:
		Globals.UP:
			animated_sprite.play("walk_up")
		Globals.DOWN:
			animated_sprite.play("walk_down")
		Globals.RIGHT:
			animated_sprite.play("walk_right")
		Globals.LEFT:
			animated_sprite.play("walk_left")
		Globals.UP_RIGHT:
			animated_sprite.play("walk_up_right")
		Globals.UP_LEFT:
			animated_sprite.play("walk_up_left")
		Globals.DOWN_RIGHT:
			animated_sprite.play("walk_down_right")
		Globals.DOWN_LEFT:
			animated_sprite.play("walk_down_left")
		_: 
			animated_sprite.stop()
