extends Sprite


func _on_player_collect(player: KinematicBody2D) -> void:
	player.max_air_jumps += 1
	SavedData.player_stats.max_air_jumps += 1
	if not SavedData.first_apple_eaten:
		SavedData.first_apple_eaten = true
		player.get_parent().show_first_apple_eaten_dialogue()
