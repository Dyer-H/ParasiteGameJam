extends CharacterBody2D

var speed: int = 50
var input_vector: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	movement_loop()

func movement_loop() -> void:
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")

	input_vector = input_vector.normalized()

	var iso_vector = Vector2(
		input_vector.x - input_vector.y,
		(input_vector.x + input_vector.y) * 0.5
	)

	velocity = iso_vector * speed
	move_and_slide()
