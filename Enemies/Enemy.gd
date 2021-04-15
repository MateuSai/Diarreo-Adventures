extends Character
class_name Enemy

export(bool) var inverse_direction: bool = false
var direction: int = 1 setget set_direction


func _init() -> void:
	if randi() % 2 == 0:
		direction *= -1


func set_direction(new_direction: int) -> void:
	direction = new_direction
	if direction == 1:
		if not inverse_direction:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	elif direction == -1:
		if not inverse_direction:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
			
			
func apply_movement() -> void:
	velocity.x = direction * speed

