extends AudioRandomizer


func _on_ExplosionSound_finished() -> void:
	queue_free()
