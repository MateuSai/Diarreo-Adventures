extends AnimatedSprite


func _on_Dust_animation_finished() -> void:
	queue_free()
