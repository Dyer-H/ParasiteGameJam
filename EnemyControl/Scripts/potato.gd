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
