extends FiniteStateMachine

onready var sprite: Sprite = parent.get_node("Sprite")
onready var attack_sprite: Sprite = parent.get_node("AttackSprite")
onready var hitbox: Area2D = parent.get_node("HitBox")
onready var animation_player: AnimationPlayer = parent.get_node("AnimationPlayer")
onready var coyote_jump_timer: Timer = parent.get_node("CoyoteJumpTimer")


func _init() -> void:
	_add_state("spawn")
	_add_state("teleport")
	_add_state("idle")
	_add_state("run")
	_add_state("jump_up")
	_add_state("jump_down")
	_add_state("attack")
	_add_state("hurt")
	_add_state("dead")
	
	
func _ready() -> void:
	if SavedData.first_game:
		self.state = states.idle
	else:
		self.state = states.spawn
	
	
func _state_logic(delta: float) -> void:
	parent.apply_friction()
	
	if state != states.spawn:
		parent.apply_gravity(delta)
		if state != states.hurt and state != states.dead:
			parent.get_input()
		
			if parent.direction < 0:
				sprite.flip_h = true
				attack_sprite.flip_h = true
				attack_sprite.offset.x = -abs(attack_sprite.offset.x)
				hitbox.position.x = -abs(hitbox.position.x)
				hitbox.direction = -1
			elif parent.direction > 0:
				sprite.flip_h = false
				attack_sprite.flip_h = false
				attack_sprite.offset.x = abs(attack_sprite.offset.x)
				hitbox.position.x = abs(hitbox.position.x)
				hitbox.direction = 1
		
		
func _get_transition() -> int:
	match state:
		states.spawn:
			return _change_state_after_animation()
		states.idle:
			if not parent.is_on_floor():
				return states.jump_up
			
			if parent.direction != 0:
				return states.run
				
		states.run:
			if not parent.is_on_floor() and parent.velocity.y < 0:
				return states.jump_up
			elif not parent.is_on_floor() and parent.velocity.y >= 0:
				return states.jump_down
				
			if parent.direction == 0:
				return states.idle
				
		states.jump_up:
			if parent.velocity.y > 0:
				return states.jump_down
				
		states.jump_down:
			if parent.is_on_floor():
				if parent.direction == 0:
					return states.idle
				else:
					return states.run
					
		states.attack:
			return _change_state_after_animation()
						
		states.hurt:
			return _change_state_after_animation()
	return -1
	
	
func _change_state_after_animation() -> int:
	if not animation_player.is_playing():
		if parent.is_on_floor():
			if parent.direction == 0:
				return states.idle
			else:
				return states.run
		else:
			if parent.velocity.y <= 0:
				return states.jump_up
			else:
				return states.jump_down
	return -1
	
	
func _enter_state(previous_state: int, new_state: int) -> void:
	if new_state == states.teleport:
		animation_player.play_backwards("spawn")
		parent.can_move = false
		parent.can_attack = false
	else:
		animation_player.play(states.keys()[new_state])
		
		if new_state == states.jump_down and previous_state == states.run:
			parent.can_coyote_jump = true
			coyote_jump_timer.start()


func _exit_state(state_exited: int) -> void:
	if state_exited == states.jump_down or state_exited == states.attack or state_exited == states.hurt:
		if state_exited == states.jump_down:
			parent.spawn_dust("after_jump_dust")
		if parent.is_on_floor():
			parent.air_jumps = 0
