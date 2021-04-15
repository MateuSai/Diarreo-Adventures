extends Sprite


func _on_player_collect(player: KinematicBody2D) -> void:
	player.max_hp += 1
	SavedData.player_stats.max_hp += 1
	if  not SavedData.first_meat_eaten:
		SavedData.first_meat_eaten = true
		player.get_parent().show_first_meat_eaten_dialogue()
