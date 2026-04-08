extends CharacterBody2D

class_name Player

@export var projectile:PackedScene
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_numbers_origin = $DamageNumbersOrigin

var stats = preload("res://PlayerControl/Resources/player_stats.tres")

const DASH_DURATION: float = 0.2 # Dash time (seconds)
var stamRegen: bool = false
var shot_cooldown: int = 0
var initial_speed: int
var regen_rate: int
var is_dashing: bool = false

func _ready() -> void:
	initial_speed = stats.player_speed
	regen_rate = 0
	stats.changed.connect(_on_speed_changed)

#this function will have to pass delta to the next eventually
#again because we don't want movement tied to framerate
func _physics_process(_delta: float) -> void:
	if (!is_dashing):
		get_input()
	else:
		velocity = velocity * 3
		move_and_slide()
		velocity = velocity / 3
	if (regen_rate > 0):
		regen_rate -= 1
	else:
		stats.set_stamina(stats.stamina + 1)
		regen_rate = 10
	if(Input.is_action_just_pressed("Shoot") && shot_cooldown == 0 && stats.curr_bullets > 0):
		shoot()
	if(Input.is_action_just_pressed("Dash")):
		dash()

# Boosts the player speed for a set time (DASH_DURATION)
func dash():
	if is_dashing:
		return
	else:
		if (stats.stamina > 33):
			regen_rate = 100
			stats.set_stamina(stats.stamina - 33)
			is_dashing = true
			await get_tree().create_timer(0.2).timeout
			is_dashing = false
	
func shoot() -> void:
	var dev=-15+randi_range(-5,5) # This is the starting deviation for the shot (degrees off from normal
	for i in range(stats.num_bullets): # range(number of pellets to generate)
		var newProjectile=projectile.instantiate() as Node2D
		get_tree().current_scene.add_child(newProjectile)
		newProjectile.global_position=global_position
		newProjectile.look_at(get_global_mouse_position())
		newProjectile.rotation_degrees+=(dev+(i*5-randi_range(-2,2))) # dev+(spread of each pellet)
	shot_cooldown = 20 #number of frames waited till next shot
	stats.set_curr_bullets(stats.curr_bullets - 1)

#gets vector based on values set in project settings
#discretizes then moves that direction
func get_input():
	var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var discretized_direction = Globals.discretize_movement_direction(input_direction.normalized())
	play_animation(discretized_direction)
	velocity = discretized_direction * stats.player_speed
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

func _on_pickup_range_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("pickup_coin"):
		area.get_parent().pickup_coin()
		stats.set_coins(stats.coins+5)
	if area.get_parent().has_method("heal"):
		var heal = area.get_parent().heal()
		stats.set_health(stats.health+heal)

func _on_speed_changed():
	initial_speed = stats.player_speed
