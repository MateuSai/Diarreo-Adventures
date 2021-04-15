extends Node

signal pause_requested(duration)

const PAUSE_PATTERN: String = "({p=\\d([.]\\d+)?[}])"
var pause_regex: RegEx = RegEx.new()

var pauses: Array = []


func _ready() -> void:
	var __ = pause_regex.compile(PAUSE_PATTERN)


func extract_pauses_from_string(source_string: String) -> String:
	pauses = []
	_find_pauses(source_string)
	return _extract_tags(source_string)
	
	
func _find_pauses(from_string: String) -> void:
	var found_pauses: Array = pause_regex.search_all(from_string)
	for result in found_pauses:
		var tag_string: String = result.get_string()
		var tag_position: int = _adjust_position(result.get_start(), from_string)
		
		var pause: Pause = Pause.new(tag_position, tag_string)
		pauses.append(pause)
	
	
func _extract_tags(from_string: String) -> String:
	var custom_regex: RegEx = RegEx.new()
	var __ = custom_regex.compile("({(.*?)})")
	return custom_regex.sub(from_string, "", true)
	
	
func check_at_position(pos: int) -> void:
	for pause in pauses:
		if pause.pause_pos == pos:
			emit_signal("pause_requested", pause.duration)
			
			
func _adjust_position(pos: int, source_string: String) -> int:
	var custom_tag_regex: RegEx = RegEx.new()
	var __ = custom_tag_regex.compile("({(.*?)})")
	
	var new_pos: int = pos
	var left_of_pos: String = source_string.left(pos)
	var all_prev_tags: Array = custom_tag_regex.search_all(left_of_pos)
	for tag_result in all_prev_tags:
		new_pos -= tag_result.get_string().length()
		
	var bbcode_i_regex: RegEx = RegEx.new()
	var bbcode_e_regex: RegEx = RegEx.new()
	
	__ = bbcode_i_regex.compile("\\[(?!\\/)(.*?)\\]")
	__ = bbcode_e_regex.compile("\\[\\/(.*?)\\]")
	
	var all_prev_start_bbcode: Array = bbcode_i_regex.search_all(left_of_pos)
	for tag_result in all_prev_start_bbcode:
		new_pos -= tag_result.get_string().length()
		
	var all_prev_end_bbcode: Array = bbcode_e_regex.search_all(left_of_pos)
	for tag_result in all_prev_end_bbcode:
		new_pos -= tag_result.get_string().length()
		
	return new_pos
