extends Sprite


func _on_player_collect(_player: KinematicBody2D) -> void:
	SceneChanger.change_scene_to("res://GamePassedScreen.tscn")
