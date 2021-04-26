extends Area2D

var active: bool = false


func _on_CheckPoint_player_entered(player: KinematicBody2D) -> void:
	if not active:
		player.last_checkpoint = self
		active = true
	
	
func desactivate() -> void:
	active = false
