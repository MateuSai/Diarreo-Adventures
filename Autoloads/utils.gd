extends Node

var screen_width: int = ProjectSettings.get_setting("display/window/size/width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/height")

var tile_size: int = 16

var can_pause: bool = false


func _init() -> void:
	randomize()
