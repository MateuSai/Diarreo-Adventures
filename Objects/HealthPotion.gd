extends Sprite


func _on_player_collect(player: KinematicBody2D) -> void:
	player.hp += 1
