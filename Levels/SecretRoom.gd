extends TileMap

onready var area: Area2D = get_node("Area2D")
onready var area_collision_shape: CollisionShape2D = get_node("Area2D/CollisionShape2D")
onready var tween: Tween = get_node("Tween")


func _ready() -> void:
	var __ = area.connect("body_entered", self, "_on_Area2D_body_entered")
	
	area.set_collision_layer_bit(0, false)
	area.set_collision_mask_bit(0, false)
	area.set_collision_mask_bit(1, true)


func _on_Area2D_body_entered(_player: KinematicBody2D) -> void:
	area_collision_shape.set_deferred("disabled", true)
	
	var __ = tween.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1,
										Tween.TRANS_SINE, Tween.EASE_OUT)
	__ = tween.start()
