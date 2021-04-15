extends FiniteStateMachine

onready var animation_player: AnimationPlayer = get_parent().get_node("AnimationPlayer")


func _init() -> void:
	_add_state("fly")
	_add_state("fall")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	self.state = states.fly
	
	
func _state_logic(delta: float) -> void:
	parent.apply_friction()
	
	if state != states.dead:
		parent.apply_gravity(delta)
		
		if state == states.fly or state == states.fall:
			parent.apply_movement()
		
		if not parent.is_chasing_player:
			parent.check_raycasts()
			parent.idle_fly()
		else:
			parent.chase_player()
	
	
func _get_transition() -> int:
	match state:
		states.fly:
			if parent.velocity.y > 50:
				return states.fall
		states.fall:
			if parent.velocity.y < 0:
				return states.fly
		states.hurt:
			if not animation_player.is_playing():
				return states.fly
				
	return -1
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	animation_player.play(states.keys()[new_state])
	
	if new_state == states.dead:
		parent.velocity.y = 0.0

