extends Sprite

export(String) var text: String = ""

var sign_text_initial_pos_y = 0

onready var sign_text: NinePatchRect = get_node("Node2D/NinePatchRect")
onready var label: Label = get_node("Node2D/NinePatchRect/RichTextLabel")
onready var tween: Tween = get_node("Tween")


func _ready() -> void:
	label.text = tr(text)
	sign_text.rect_position.x = -sign_text.rect_size.x/2
	sign_text_initial_pos_y = sign_text.rect_position.y


func _on_Area2D_player_entered(_player: KinematicBody2D) -> void:
	_show_sign_text()


func _on_Area2D_player_exited(_player: KinematicBody2D) -> void:
	_hide_sign_text()
	
	
func _show_sign_text() -> void:
	var __ = tween.stop_all()
	__ = tween.interpolate_property(sign_text, "rect_position", Vector2(sign_text.rect_position.x,
									sign_text_initial_pos_y), Vector2(sign_text.rect_position.x, -45), 0.6,
									Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	__ = tween.interpolate_property(sign_text, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.6, Tween.TRANS_QUART,
									Tween.EASE_IN)
	__ = tween.start()
	
	
func _hide_sign_text() -> void:
	var __ = tween.stop_all()
	__ = tween.interpolate_property(sign_text, "rect_position", Vector2(sign_text.rect_position.x, -40),
									Vector2(sign_text.rect_position.x, sign_text_initial_pos_y), 0.6,
									Tween.TRANS_SINE, Tween.EASE_OUT_IN)
	__ = tween.interpolate_property(sign_text, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.6,
									Tween.TRANS_QUART, Tween.EASE_OUT)
	__ = tween.start()
