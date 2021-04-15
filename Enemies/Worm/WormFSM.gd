extends FiniteStateMachine

onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")


func _init() -> void:
	_add_state("crawl")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	self.state = states.crawl
	
	
func _state_logic(delta: float) -> void:
	parent.apply_gravity(delta)
	parent.apply_friction()
	if state == states.crawl:
		parent.apply_movement()
		parent.check_raycasts()
	
	
func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.crawl
	return -1
	
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	if new_state == states.hurt:
		parent.can_move = false
	animation_player.play(states.keys()[new_state])
	
	
func _exit_state(state_exited: int) -> void:
	if state_exited == states.hurt:
		parent.can_move = true
