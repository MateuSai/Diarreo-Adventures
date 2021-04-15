extends LeverOrButton

const TEXTURES: Dictionary = {
	'normal': preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/buttom.png"),
	'pressed': preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/buttom_pressed.png")
}


func _on_Button_player_entered(_player: KinematicBody2D) -> void:
	emit_signal("activated")
	sprite.texture = TEXTURES.pressed


func _on_Button_player_exited(_player: KinematicBody2D) -> void:
	sprite.texture = TEXTURES.normal
