extends Reference
class_name Pause

const FLOAT_PATTERN: String = "\\d+\\.\\d+"
var pause_pos: int = 0
var duration: float = 0.0


func _init(position: int, tag_string: String) -> void:
	var duration_regex: RegEx = RegEx.new()
	var __ = duration_regex.compile(FLOAT_PATTERN)
	
	duration = float(duration_regex.search(tag_string).get_string())
	pause_pos = int(clamp(position - 1, 0, abs(position)))
