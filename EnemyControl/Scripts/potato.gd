extends CharacterBody2D

@onready var player: CharacterBody2D = get_node("../Player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var detection_zone = $DetectionArea/CollisionShape2D
@onready var detection_area = $DetectionArea/CollisionShape2D

var stats = preload("res://PlayerControl/Resources/player_stats.tres")
const SPEED = 40.0
@export var health = 24
@export var dmg = 2
var dead = false
var player_in_area = false
var player_hit = false
var hit_cooldown = 0

#will probably change this later so that this doesn't get recalculated every frame
#can probably get away with once every half second or something
func _physics_process(_delta: float) -> void:
	if dead:
		return
	elif !dead:
		# Make sure the collision area is on if it isn't dead
		detection_area.disabled = false
		if player_in_area:
			move_to_position(player.position)
		else:
			animated_sprite.stop()
	else:
		# Make sure the collision area is off if it is dead
		detection_area.disabled = true
	if player_hit and hit_cooldown <= 0:
		stats.set_health(stats.health - dmg)
		hit_cooldown = 25
	if hit_cooldown >= 0:
		hit_cooldown -= 1

func move_to_position(target_position: Vector2) -> void:
	var direction = target_position - position
	var discretized_direction = Globals.discretize_movement_direction(direction.normalized())
	play_animation(discretized_direction)
	velocity = discretized_direction * SPEED
	move_and_slide()

#expects a discretized vector (defined in global class)
func play_animation(direction: Vector2):	
	match direction:
		Globals.UP:
			animated_sprite.play("up")
		Globals.DOWN:
			animated_sprite.play("down")
		Globals.RIGHT:
			animated_sprite.play("right")
		Globals.LEFT:
			animated_sprite.play("left")
		Globals.UP_RIGHT:
			animated_sprite.play("up_right")
		Globals.UP_LEFT:
			animated_sprite.play("up_left")
		Globals.DOWN_RIGHT:
			animated_sprite.play("down_right")
		Globals.DOWN_LEFT:
			animated_sprite.play("down_left")
			
func take_damage(damage:int,crit:float):
	var is_crit = crit > randf() # Calculating crit based off chance
	if is_crit:
		damage = 2*damage
	health -= damage
	# Displaying Damage Numbers
	damage_numbers_origin.display_number(damage, damage_numbers_origin.global_position, is_crit)
	
	
	if health <= 0:
		dead = true
		self.queue_free()
		return
