extends KinematicBody2D
class_name Character

const FRICTION: float = 0.15
const GRAVITY: int = 300

var can_move: bool = true setget set_can_move
export(int) var speed: int = 120
var velocity: Vector2 = Vector2.ZERO

var is_immune: bool = false

export(int) var max_hp: int = 2 setget set_max_hp
var hp: int = max_hp setget set_hp
signal hp_changed(previous_hp, actual_hp)
signal killed()
signal max_hp_increased()
export(int) var damage: int = 1

onready var state_machine: Node = get_node("FiniteStateMachine")
onready var sprite: Sprite = get_node("Sprite")
onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
onready var hitbox: Area2D = get_node_or_null("HitBox")


func apply_gravity(delta: float) -> void:
	velocity.y += GRAVITY * delta
	
	
func apply_friction() -> void:
	velocity.x = lerp(velocity.x, 0.0, FRICTION)


func _physics_process(_delta: float) -> void:
	velocity = move_and_slide(velocity, Vector2.UP)
	
	
func take_damage(dam: int, direction: int) -> void:
	if not is_immune:
		self.hp -= dam
		if hp > 0:
			velocity += Vector2(direction * 150, -50)
			state_machine.set_state(state_machine.states.hurt)
		else:
			velocity += Vector2(direction * 250, -50)
			state_machine.set_state(state_machine.states.dead)
	
	
func set_hp(new_hp: int) -> void:
	var previous_hp: int = hp
	hp = int(clamp(new_hp, 0, max_hp))
	emit_signal("hp_changed", previous_hp, hp)
	if hp == 0:
		emit_signal("killed")
		
		
func set_max_hp(new_max: int) -> void:
	max_hp = new_max
	emit_signal("max_hp_increased")
	self.hp = max_hp
	
	
func set_can_move(new_value: bool) -> void:
	can_move = new_value
