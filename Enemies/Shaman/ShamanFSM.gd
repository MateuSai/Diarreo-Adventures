extends FiniteStateMachine

onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")


func _init() -> void:
	_add_state("idle")
	_add_state("hostile")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	self.state = states.idle
	
	
func _state_logic(delta: float) -> void:
	parent.apply_gravity(delta)
	parent.apply_friction()
	
	
func _get_transition() -> int:
	match state:
		states.hurt:
			if not animation_player.is_playing():
				return states.hostile
				
	return -1
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	if new_state == states.hostile:
		animation_player.play("throw")
	else:
		animation_player.play(states.keys()[new_state])
