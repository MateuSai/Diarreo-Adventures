extends GroundEnemy

var directions: Array = [1, 0, -1]

onready var player: KinematicBody2D = null

onready var change_direction_timer: Timer = get_node("ChangeDirectionTimer")


func _ready() -> void:
	if direction == -1:
		sprite.flip_h = true


func set_direction(new_direction: int) -> void:
	direction = new_direction
	if direction == 1:
		sprite.flip_h = false
		hitbox.get_node("CollisionShape2D").position.x = abs(hitbox.get_node("CollisionShape2D").position.x)
		hitbox.direction = direction
	elif direction == -1:
		sprite.flip_h = true
		hitbox.get_node("CollisionShape2D").position.x = -abs(hitbox.get_node("CollisionShape2D").position.x)
		hitbox.direction = direction
		
		
func chase_player() -> void:
	if player.global_position.x - global_position.x > 0:
		self.direction = 1
	else:
		self.direction = -1


func _on_ChangeDirectionTimer_timeout() -> void:
	set_direction(directions[randi() % directions.size()])


func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	player = body
	change_direction_timer.stop()
	state_machine.set_state(state_machine.states.chase)
