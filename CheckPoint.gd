extends Area2D

var active: bool = false


func _on_CheckPoint_player_entered(player: KinematicBody2D) -> void:
	if not active:
		if player.last_checkpoint != null:
			player.last_checkpoint.desactivate()
		player.last_checkpoint = self
		active = true
	
	
func desactivate() -> void:
	active = false
