extends CanvasLayer

const HEART_SCENE: PackedScene = preload("res://UI/Heart.tscn")

onready var heart_container: HBoxContainer = get_node("Hearts")


func _on_Player_spawn_hearts(num: int) -> void:
	for i in num:
		var heart: TextureRect = HEART_SCENE.instance()
		heart_container.add_child(heart)


func _on_Player_hp_changed(previous_hp: int, actual_hp: int) -> void:
	var hp_difference: int = actual_hp - previous_hp
	if hp_difference > 0:
		for i in range(previous_hp, actual_hp):
			var current_heart: TextureRect = heart_container.get_child(i)
			current_heart.recover_heart()
	elif hp_difference < 0:
		for i in range(previous_hp, actual_hp, -1):
			var current_heart: TextureRect = heart_container.get_child(i - 1)
			current_heart.destroy_heart()
