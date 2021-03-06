extends Area2D
class_name HitBox

const HIT_EFFECT_SCENE: PackedScene = preload("res://Player/HitEffect.tscn")

export(int) var direction = 1

var character_inside_hitbox: bool = false

onready var parent: Node2D = get_parent()
onready var collision_shape: CollisionShape2D = get_node("CollisionShape2D")
onready var sound: AudioStreamPlayer = get_node_or_null("Sound")

func _ready() -> void:
	var __ = connect("body_entered", self, "_on_body_entered")
	__ = connect("body_exited", self, "_on_body_exited")
	__ = connect("area_entered", self, "_on_area_entered")
	
	set_collision_mask_bit(6, true)
	
	if sound != null:
		sound.volume_db = 8
	
	
func _on_body_entered(body: KinematicBody2D) -> void:
	character_inside_hitbox = true
	while character_inside_hitbox:
		body.take_damage(parent.damage, direction)
		
		_spawn_hit_effect(body.global_position)
		
		if sound != null:
			sound.play()
			
		yield(get_tree().create_timer(1.2), "timeout")
			
		
func _on_body_exited(_body: KinematicBody2D) -> void:
	character_inside_hitbox = false
	
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("destroyables"):
		area.get_parent().destroy()
	else:
		area.turn_lever(direction)
		
	_spawn_hit_effect(area.global_position)
		
	if sound != null:
		sound.play()
	
	
func _spawn_hit_effect(pos: Vector2) -> void:
	var hit_effect: AnimatedSprite = HIT_EFFECT_SCENE.instance()
	hit_effect.global_position = pos
	if direction == 1:
		hit_effect.flip_h = true
	get_parent().get_parent().add_child(hit_effect)
