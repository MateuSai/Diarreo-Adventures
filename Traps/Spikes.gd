extends Area2D

onready var sound: AudioStreamPlayer = get_node("Sound")


func _on_player_entered(player: KinematicBody2D) -> void:
	sound.play()
	player.go_to_checkpoint()
	player.take_damage(1, 0)
