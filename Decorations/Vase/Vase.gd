extends AnimatedSprite

onready var area: Area2D = get_node("Area2D")


func destroy() -> void:
	area.queue_free()
	play("destroy")
