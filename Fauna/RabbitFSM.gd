extends FiniteStateMachine

onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")


func _init() -> void:
	_add_state("idle")
	_add_state("move")


func _state_logic(delta: float) -> void:
	parent.apply_gravity(delta)
	parent.apply_friction()
	
	if state == states.move:
		parent.check_raycasts()
	
	
func _enter_state(_previous_state: int, new_state: int) -> void:
	animation_player.play(states.keys()[new_state])
	
	if new_state == states.idle:
		parent.direction = 0
	else:
		if randi() % 2 == 0:
			parent.direction = 1
		else:
			parent.direction = -1


func _on_Timer_timeout() -> void:
	if randi() % 2 == 0:
		set_state(states.idle)
	else:
		set_state(states.move)
