extends AnimatedSprite


func _ready() -> void:
	play()


func _on_HitEffect_animation_finished() -> void:
	queue_free()
