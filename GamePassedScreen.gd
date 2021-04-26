extends CanvasLayer


func _on_Timer_timeout() -> void:
	SceneChanger.change_scene_to("res://Menu.tscn")
