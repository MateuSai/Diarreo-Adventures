extends RigidBody2D

const EXPLOSION_SCENE: PackedScene = preload("res://Enemies/Shaman/fake_explosion_particles.tscn")

var damage: int = 0
var direction: int = 0

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func _ready() -> void:
	animation_player.play("thrown")


func _on_Timer_timeout():
	animation_player.play("explode")
	
	
func destroy() -> void:
	_spawn_explosion()
	queue_free()
	
	
func _spawn_explosion() -> void:
	var explosion: Node2D = EXPLOSION_SCENE.instance()
	explosion.position = position
	get_parent().add_child(explosion)


func _on_Area2D_body_entered(player: KinematicBody2D) -> void:
	player.take_damage(damage, direction)
	destroy()
