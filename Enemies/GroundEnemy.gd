extends Enemy
class_name GroundEnemy

onready var floor_raycasts: Dictionary = {
	"right": get_node("FloorRayCasts/RightRayCast"),
	"left": get_node("FloorRayCasts/LeftRayCast")
}
onready var wall_raycasts: Dictionary = {
	"right": get_node("WallRayCasts/RightRayCast"),
	"left": get_node("WallRayCasts/LeftRayCast")
}


func check_raycasts() -> void:
	if direction == 1:
		if not floor_raycasts.right.is_colliding() or wall_raycasts.right.is_colliding():
			self.direction = -1
	elif direction == -1:
		if not floor_raycasts.left.is_colliding() or wall_raycasts.left.is_colliding():
			self.direction = 1
