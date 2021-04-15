extends AnimatedSprite

export(int) var link_code: int = 0

const SPIKES_SCENE: PackedScene = preload("res://Traps/SpikesTrap.tscn")

var last_spikes_collided: KinematicBody2D = null

onready var traps_container: Node2D = owner.get_node("Traps")
onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func _change_state() -> void:
	animation_player.play("shoot")
	
	
func shoot_spikes() -> void:
	var spikes: KinematicBody2D = SPIKES_SCENE.instance()
	var __ = spikes.connect("collided", self, "_on_spikes_collided")
	spikes.rotation = rotation
	spikes.position = position
	traps_container.add_child(spikes)
	
	
func _on_spikes_collided(spikes: KinematicBody2D) -> void:
	if last_spikes_collided != null:
		last_spikes_collided.queue_free()
	last_spikes_collided = spikes
