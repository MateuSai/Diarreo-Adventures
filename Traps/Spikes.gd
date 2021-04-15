extends Area2D


func _on_player_entered(player: KinematicBody2D) -> void:
	player.go_to_checkpoint()
	player.take_damage(1, 0)
