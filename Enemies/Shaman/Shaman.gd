extends Enemy

const BOMB_SCENE: PackedScene = preload("res://Enemies/Shaman/Bomb.tscn")
const CURE_POTION: PackedScene = preload("res://Objects/CurePotion.tscn")

var player_seen: bool = false
var player: KinematicBody2D = null

onready var bomb_initial_position: Position2D = get_node("BombInitialPosition")
onready var player_detector: Area2D = get_node("PlayerDetector")


func _ready() -> void:
	if direction == -1:
		sprite.flip_h = true
		
		
func _process(_delta: float) -> void:
	if player_seen:
		if global_position.x > player.global_position.x:
			self.direction = -1
		else:
			self.direction = 1


func thrown_bomb() -> void:
	print((player.global_position - position).normalized())
	if hp > 2:
		var bomb: RigidBody2D = BOMB_SCENE.instance()
		bomb.global_position = bomb_initial_position.global_position
		bomb.damage = damage
		bomb.direction = direction
		get_parent().add_child(bomb)
		bomb.apply_central_impulse((player.global_position - position).normalized() * 200)
	else:
		for i in [-1, 1]:
			var bomb: RigidBody2D = BOMB_SCENE.instance()
			bomb.global_position = bomb_initial_position.global_position
			bomb.damage = damage
			bomb.direction = direction
			get_parent().add_child(bomb)
			bomb.apply_central_impulse(((player.global_position - position).normalized() + Vector2(0, 0.2 * i)) * 200)
			


func _on_PlayerDetector_body_entered(body: KinematicBody2D) -> void:
	player = body
	player_seen = true
	state_machine.set_state(state_machine.states.hostile)
	player_detector.queue_free()


func _on_Shaman_killed() -> void:
	_spawn_potion()
	
	
func _spawn_potion() -> void:
	var potion: Sprite = CURE_POTION.instance()
	potion.position = position + Vector2(0, 3)
	owner.get_node("Objects").call_deferred("add_child", potion)
