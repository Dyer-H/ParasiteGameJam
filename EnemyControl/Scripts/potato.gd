extends CharacterBody2D

@onready var player: CharacterBody2D = get_node("../Player")
@onready var animated_sprite = $AnimatedSprite2D
const SPEED = 40.0

#will probably change this later so that this doesn't get recalculated every frame
#can probably get away with once every half second or something
func _physics_process(_delta: float) -> void:
	move_to_position(player.position)

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
