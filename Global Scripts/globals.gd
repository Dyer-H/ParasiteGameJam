extends Node
class_name Globals

#Directions for movement (primarily for discretization)
const UP = Vector2(0,-1)
const DOWN = Vector2(0,1)
const RIGHT = Vector2(1,0)
const LEFT = Vector2(-1, 0)

#for orthogonal directions
const UP_RIGHT = Vector2(cos(PI/6), -sin(PI/6))
const UP_LEFT = Vector2(-cos(PI/6), -sin(PI/6))
const DOWN_RIGHT = Vector2(cos(PI/6), sin(PI/6))
const DOWN_LEFT = Vector2(-cos(PI/6), sin(PI/6))

#function expects a normalized vector as input
static func discretize_movement_direction(direction: Vector2) -> Vector2:
	if (direction == Vector2(0,0)):
		return Vector2(0,0)
	var difference = (direction - UP).length_squared()
	var final_direction = UP
	if ((direction - DOWN).length_squared() < difference):
		difference = (direction - DOWN).length_squared()
		final_direction = DOWN
	if ((direction - RIGHT).length_squared() < difference):
		difference = (direction - RIGHT).length_squared()
		final_direction = RIGHT
	if ((direction - LEFT).length_squared() < difference):
		difference = (direction - LEFT).length_squared()
		final_direction = LEFT
	if ((direction - UP_RIGHT).length_squared() < difference):
		difference = (direction - UP_RIGHT).length_squared()
		final_direction = UP_RIGHT
	if ((direction - UP_LEFT).length_squared() < difference):
		difference = (direction - UP_LEFT).length_squared()
		final_direction = UP_LEFT
	if ((direction - DOWN_RIGHT).length_squared() < difference):
		difference = (direction - DOWN_RIGHT).length_squared()
		final_direction = DOWN_RIGHT
	if ((direction - DOWN_LEFT).length_squared() < difference):
		difference = (direction - DOWN_LEFT).length_squared()
		final_direction = DOWN_LEFT
	return final_direction
