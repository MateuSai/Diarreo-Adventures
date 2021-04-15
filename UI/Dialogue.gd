extends TextureRect
class_name Dialogue

var playing_audio: bool = false

signal message_completed()

onready var label: RichTextLabel = get_node("RichTextLabel")
onready var type_timer: Timer = get_node("TypeTimer")
onready var pause_timer: Timer = get_node("PauseTimer")
onready var type_sound: AudioStreamPlayer = get_node("typeSound")
onready var pause_calculator: Node = get_node("PauseCalculator")
onready var finished_indicator: Sprite = get_node("FinishedIndicator")


func update_message(message: String) -> void:
	finished_indicator.hide()
	label.bbcode_text = pause_calculator.extract_pauses_from_string(message)
	label.visible_characters = 0
	type_timer.start()
	playing_audio = true
	type_sound.play()
	
	
func message_is_fully_visible() -> bool:
	if label.visible_characters >= label.text.length():
		return true
	return false


func _on_TypeTimer_timeout() -> void:
	if label.visible_characters < label.text.length():
		label.visible_characters += 1
		pause_calculator.check_at_position(label.visible_characters)
	else:
		type_timer.stop()
		playing_audio = false
		finished_indicator.show()
		emit_signal("message_completed")


func _on_typeSound_finished() -> void:
	if playing_audio:
		type_sound.play()


func _on_PauseCalculator_pause_requested(duration: float) -> void:
	playing_audio = false
	type_timer.stop()
	pause_timer.wait_time = duration
	pause_timer.start()


func _on_PauseTimer_timeout() -> void:
	playing_audio = true
	type_sound.play()
	type_timer.start()
