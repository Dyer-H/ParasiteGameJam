extends CharacterBody2D

@onready var player = $"../../Player"
@onready var animated_sprite = $AnimatedSprite2D
@onready var damage_numbers_origin = $DamageNumbersOrigin
@onready var detection_zone = $DetectionArea/CollisionShape2D
@onready var detection_area = $DetectionArea/CollisionShape2D

var stats = preload("res://PlayerControl/Resources/player_stats.tres")
const SPEED: float = 40.0
@export var health: int = 24
@export var dmg: int = 2
var dead: bool = false
var player_in_area: bool = false
var player_hit: bool = false
var hit_cooldown: int = 0
var chase_on_hit = false

@export var item_drop: Array[PackedScene]
@export var item_drop_chances: Array[float]

#will probably change this later so that this doesn't get recalculated every frame
#can probably get away with once every half second or something
func _physics_process(_delta: float) -> void:
	if dead:
		return
	elif !dead:
		# Make sure the collision area is on if it isn't dead
		detection_area.disabled = false
		if chase_on_hit:
			move_to_position(player.position + Vector2(0,10))
		elif player_in_area:
			move_to_position(player.position + Vector2(0,10))
		else:
			animated_sprite.stop()
	else:
		# Make sure the collision area is off if it is dead
		detection_area.disabled = true
	if player_hit and hit_cooldown <= 0:
		print("hit")
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
			
func take_damage(damage:int, crit:float):
	var is_crit = crit > randf() # Calculating crit based off chance
	if is_crit:
		damage = 2*damage
	health -= damage
	if not player_in_area:
		chase_on_hit = true
	# Displaying Damage Numbers
	damage_numbers_origin.display_number(damage, damage_numbers_origin.global_position, is_crit)
	
	
	if health <= 0:
		dead = true
		
		if item_drop.size() >0:
			_fix_item_drop_arrays()
			_drop_item()
			
		self.queue_free()
		return

# Resize the arrays so the chance stays with the items
func _fix_item_drop_arrays() -> void:
	if item_drop_chances.size() < item_drop.size():
		item_drop_chances.resize(item_drop.size())
	elif item_drop.size() < item_drop_chances.size():
		item_drop.resize(item_drop_chances.size())
		

func _drop_item() -> void:
	var drops = randi_range(0,3)
	for d in drops:
		var total_weight: float = 0.0
		for weight in item_drop_chances:
			total_weight += weight
		
		var rand: float = randf_range(0.0, total_weight)
		var updated_drop_value: float = 0.0
		
		for i in item_drop_chances.size():
			updated_drop_value += item_drop_chances[i]
			if rand <= updated_drop_value:
				if item_drop[i] == null:
					return
				
				var item: Node2D = item_drop[i].instantiate()
				var angle = randf() * TAU  # TAU = 2 * PI
				var distance = randf_range(0,10)
				var offset = Vector2(cos(angle), sin(angle)) * distance
				item.global_position = global_position + offset
				get_tree().current_scene.call_deferred("add_child", item)
				break
