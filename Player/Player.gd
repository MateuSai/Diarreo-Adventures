extends Character

const DUST_SCENE: PackedScene = preload("res://Dust/Dust.tscn")

signal spawn_hearts(num)

var can_attack: bool = true
var air_jumps: int = 0
var max_air_jumps: int = 0
var jump_force: int = 110
var can_coyote_jump: bool = false

var last_save_point: AnimatedSprite = null
var last_checkpoint: Area2D = null

var direction: int = 1

onready var checkpoint_tween: Tween = get_node("CheckPointTween")
onready var immunity_timer: Timer = get_node("ImmunityTimer")
onready var teleport_sound: AudioStreamPlayer = get_node("TeleportSound")


func _ready() -> void:
	# Load stats
	max_hp = SavedData.player_stats.max_hp
	max_air_jumps = SavedData.player_stats.max_air_jumps
	
	emit_signal("spawn_hearts", max_hp)


func get_input() -> void:
	direction = 0
	if can_move:
		if Input.is_action_pressed("ui_right"):
			direction = 1
		if Input.is_action_pressed("ui_left"):
			direction = -1
		velocity.x = lerp(velocity.x, direction * speed, FRICTION)
		
		if Input.is_action_just_pressed("ui_jump") and (air_jumps < max_air_jumps or is_on_floor() or can_coyote_jump):
			jump()
		if Input.is_action_just_released("ui_jump"):
			jump_cut()
	if Input.is_action_just_pressed("ui_attack") and can_attack:
		attack()
		
		
func jump() -> void:
	if not is_on_floor() and not can_coyote_jump:
		air_jumps += 1
	velocity.y = -jump_force
	spawn_dust("before_jump_dust")
	
	
func jump_cut() -> void:
	if velocity.y < -50:
		velocity.y = -50
	
	
func attack() -> void:
	state_machine.set_state(state_machine.states.attack)
	
	
func spawn_dust(anim: String) -> void:
	var Dust: AnimatedSprite = DUST_SCENE.instance()
	Dust.position = position
	get_parent().add_child(Dust)
	Dust.play(anim)
	
	
func go_to_checkpoint() -> void:
	var __ = checkpoint_tween.interpolate_property(self, "position", position, last_checkpoint.global_position, 0.4,
												   Tween.TRANS_EXPO, Tween.EASE_OUT)
	__ = checkpoint_tween.start()
	
	
func teleport() -> void:
	state_machine.set_state(state_machine.states.teleport)
	teleport_sound.play()


func _on_ImmunityTimer_timeout():
	is_immune = false


func _on_Player_hp_changed(previous_hp: int, actual_hp: int) -> void:
	if actual_hp < previous_hp:
		is_immune = true
		immunity_timer.start()


func _on_Player_max_hp_increased() -> void:
	emit_signal("spawn_hearts", 1)


func _on_CoyoteJumpTimer_timeout() -> void:
	can_coyote_jump = false
	
	
func set_can_move(new_value: bool) -> void:
	can_move = new_value
	Utils.can_pause = new_value
