extends GroundEnemy


func set_direction(new_direction: int) -> void:
	direction = new_direction
	hitbox.direction = direction
