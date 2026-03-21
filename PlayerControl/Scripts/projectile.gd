extends Area2D

const speed=3000
var damage = 3
var crit_chance:float = 0.18
var bullet_range:float = 0.2 # Range is in seconds

func _ready():
	await get_tree().create_timer(bullet_range).timeout
	queue_free()
	
func _process(delta: float) -> void:
	position+=transform.x*(delta*speed)


func get_damage():
	return damage

func get_crit():
	return crit_chance

func free_node():
	self.queue_free()
