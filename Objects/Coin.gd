extends AnimatedSprite

var collected: bool = false


func _on_player_collect(_player: KinematicBody2D) -> void:
	collected = true
	SavedData.coins_collected += 1
	play("collect")


func _on_Coin_animation_finished() -> void:
	if collected:
		queue_free()
