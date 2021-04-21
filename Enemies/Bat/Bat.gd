extends Enemy

var initial_pos_y: float = 0.0
var impulse_force: int = 60

var is_chasing_player: bool = false
var can_descend: bool = true

var player: KinematicBody2D = null

onready var wall_raycasts: Dictionary = {
	"right": get_node("WallRayCasts/RightRayCast"),
	"left": get_node("WallRayCasts/LeftRayCast")
}


func _ready() -> void:
	initial_pos_y = position.y
	
	if direction == 1:
		sprite.flip_h = true
	
	
func idle_fly() -> void:
	if position.y > initial_pos_y + 5:
			velocity.y = -impulse_force
			
			
func chase_player() -> void:
	var dir_vector: Vector2 = player.global_position - global_position
	var dir = dir_vector.normalized()
	if dir.x > 0:
		self.direction = 1
	elif dir.x < 0:
		self.direction = -1
		
	if player.global_position.y < global_position.y or (dir.x < 0.1 and dir.x > -0.1
														and dir_vector.y < 40 and not can_descend):
		velocity.y = -impulse_force


func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	player = body
	is_chasing_player = true
	
	
func check_raycasts() -> void:
	if direction == 1:
		if wall_raycasts.right.is_colliding():
			self.direction = -1
	elif direction == -1:
		if wall_raycasts.left.is_colliding():
			self.direction = 1


func _on_Timer_timeout() -> void:
	can_descend = not can_descend
