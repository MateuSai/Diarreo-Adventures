extends CanvasLayer

var scene_path: String = ""

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")


func change_scene_to(new_scene: String) -> void:
	if not animation_player.is_playing():
		scene_path = new_scene
		animation_player.play("change_scene")
	
	
func change_scene() -> void:
	var __ = get_tree().change_scene(scene_path)
