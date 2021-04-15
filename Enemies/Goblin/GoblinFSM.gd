extends FiniteStateMachine

onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")
onready var attack_raycasts: Node2D = parent.get_node("AttackRayCasts")


func _init() -> void:
	_add_state("idle")
	_add_state("run")
	_add_state("chase")
	_add_state("attack")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	self.state = states.idle
	
	
func _state_logic(delta: float) -> void:
	parent.apply_gravity(delta)
	parent.apply_friction()
	
	if state == states.chase:
		parent.chase_player()
	if state != states.hurt and state != states.dead:
		parent.apply_movement()
		
	if state == states.run:
		parent.check_raycasts()
		
		
func _get_transition() -> int:
	match state:
		states.idle:
			if parent.direction != 0:
				return states.run
				
		states.run:
			if parent.direction == 0:
				return states.idle
				
		states.chase:
			for raycast in attack_raycasts.get_children():
				if raycast.is_colliding():
					return states.attack
				
		states.attack:
			if not animation_player.is_playing():
				return states.chase
				
		states.hurt:
			if not animation_player.is_playing():
				return states.chase
	return -1
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	if new_state == states.chase:
		animation_player.play("run")
	else:
		animation_player.play(states.keys()[new_state])
		
	if new_state == states.attack:
		parent.direction = 0
