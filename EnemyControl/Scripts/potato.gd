extends CharacterBody2D

@onready var player: CharacterBody2D = get_node("../Player")
@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 40.0
var health = 100
var dmg = 2
var dead = false
var player_in_area = false
var player_hit = false
var hit_cooldown = 0

#constants used for discretizing movement
const UP = Vector2(0,1)
const DOWN = Vector2(0,-1)
const RIGHT = Vector2(1,0)
const LEFT = Vector2(-1, 0)
#number comes from sqrt(2)
const UP_RIGHT = Vector2(0.7071, 0.7071)
const UP_LEFT = Vector2(-0.7071, 0.7071)
const DOWN_RIGHT = Vector2(0.7071, -0.7071)
const DOWN_LEFT = Vector2(-0.7071, -0.7071)

#used for the same reason as above
enum Direction {
	UP,
	DOWN,
	RIGHT,
	LEFT,
	UP_RIGHT,
	UP_LEFT,
	DOWN_RIGHT,
	DOWN_LEFT,
}

func ready():
	dead = false

#will probably change this later so that this doesn't get recalculated every frame
#can probably get away with once every half second or something
func _physics_process(_delta: float) -> void:
	if !dead:
		# Make sure the collision area is on if it isn't dead
		$DetectionArea/CollisionShape2D.disabled = false
		if player_in_area:
			move_to_position(player.position)
	else:
		# Make sure the collision area is off if it is dead
		$DetectionArea/CollisionShape2D.disabled = true
	if player_hit and hit_cooldown <= 0:
		player.take_damage(dmg)
		hit_cooldown = 25
	if hit_cooldown >= 0:
		hit_cooldown -= 1

func move_to_position(target_position: Vector2) -> void:
	var direction = target_position - position
	var discretized_direction = discretize_movement_direction(direction.normalized())
	velocity = discretized_direction * SPEED
	move_and_slide()

#expects a normalized vector as input
#maps input to one of 8 directions
#returns a normalized vector as output
#also handles animation playing because delegating that responsibility
#to another function would significantly increase overhead
func discretize_movement_direction(direction: Vector2) -> Vector2:
	if (direction == Vector2(0,0)):
		animated_sprite.stop()
		return Vector2(0,0)
	var difference = (direction - UP).length_squared()
	var final_direction = Direction.UP
	if ((direction - DOWN).length_squared() < difference):
		difference = (direction - DOWN).length_squared()
		final_direction = Direction.DOWN
	if ((direction - RIGHT).length_squared() < difference):
		difference = (direction - RIGHT).length_squared()
		final_direction = Direction.RIGHT
	if ((direction - LEFT).length_squared() < difference):
		difference = (direction - LEFT).length_squared()
		final_direction = Direction.LEFT
	if ((direction - UP_RIGHT).length_squared() < difference):
		difference = (direction - UP_RIGHT).length_squared()
		final_direction = Direction.UP_RIGHT
	if ((direction - UP_LEFT).length_squared() < difference):
		difference = (direction - UP_LEFT).length_squared()
		final_direction = Direction.UP_LEFT
	if ((direction - DOWN_RIGHT).length_squared() < difference):
		difference = (direction - DOWN_RIGHT).length_squared()
		final_direction = Direction.DOWN_RIGHT
	if ((direction - DOWN_LEFT).length_squared() < difference):
		difference = (direction - DOWN_LEFT).length_squared()
		final_direction = Direction.DOWN_LEFT
	
	#for some reason, animations are inverted along the x-axis
	#this is hotfix, but could actually investigate later if needed
	match final_direction:
		Direction.UP:
			animated_sprite.play("down")
			return UP
		Direction.DOWN:
			animated_sprite.play("up")
			return DOWN
		Direction.RIGHT:
			animated_sprite.play("right")
			return RIGHT
		Direction.LEFT:
			animated_sprite.play("left")
			return LEFT
		Direction.UP_RIGHT:
			animated_sprite.play("down_right")
			return UP_RIGHT
		Direction.UP_LEFT:
			animated_sprite.play("down_left")
			return UP_LEFT
		Direction.DOWN_RIGHT:
			animated_sprite.play("up_right")
			return DOWN_RIGHT
		Direction.DOWN_LEFT:
			animated_sprite.play("up_left")
			return DOWN_LEFT
	#this line should never be reached
	#just required because godot can't be unsafe 
	#and will throw an error otherwise
	return Vector2(0,0)

# Detects when a body enters the area
func _on_detection_area_body_entered(body: Node2D) -> void:
	if "Player" in body.name: # Detecting if body has that player function
		player_in_area = true

# Same function as before but for body leaving the area
func _on_detection_area_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		player_in_area = false

func _on_hitbox_body_entered(body: Node2D) -> void:
	if "Player" in body.name:
		player_hit = true


func _on_damage_box_body_exited(body: Node2D) -> void:
	if "Player" in body.name:
		player_hit = false
		hit_cooldown = 0
