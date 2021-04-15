extends AnimatedSprite

onready var collision_shape: CollisionShape2D = get_node("Collectable/CollisionShape2D")
onready var reactivation_timer: Timer = get_node("ReactivationTimer")


func _on_player_collect(player: KinematicBody2D) -> void:
	player.air_jumps -= 1
	
	collision_shape.set_deferred("disabled", true)
	play("explode")
	
	reactivation_timer.start()


func _on_ReactivationTimer_timeout() -> void:
	collision_shape.set_deferred("disabled", false)
	play("explode", true)
	
	yield(get_tree().create_timer(7.0/11), "timeout")
	
	play("default")
