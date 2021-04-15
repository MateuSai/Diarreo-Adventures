extends Control

const DIALOGUE_SCENE: PackedScene = preload("res://UI/Dialogue.tscn")

signal message_requested()
signal message_completed()
signal finished()

var messages: Array = []
var active_dialogue_offset: int = 0
var is_active: bool = false
var cur_dialogue_instance: Dialogue = null

onready var enter_tween: Tween = get_node("EnterTween")
onready var leave_tween: Tween = get_node("LeaveTween")


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and is_active and cur_dialogue_instance.message_is_fully_visible():
		if active_dialogue_offset < messages.size() - 1:
			active_dialogue_offset += 1
			_show_current()
		else:
			# Hide the dialogue and delete it
			is_active = false
			var __ = leave_tween.interpolate_property(cur_dialogue_instance, "rect_position",
												cur_dialogue_instance.rect_position,
												cur_dialogue_instance.rect_position
												+ Vector2(0, cur_dialogue_instance.rect_size.y), 0.5)
			__ = leave_tween.start()


func show_messages(message_list: Array) -> void:
	if is_active:
		return
	is_active = true
	
	messages = message_list
	active_dialogue_offset = 0
	
	var dialogue: Dialogue = DIALOGUE_SCENE.instance()
	var __ = dialogue.connect("message_completed", self, "_on_message_completed")
	
	dialogue.rect_position.y = Utils.screen_height
	
	add_child(dialogue)
	cur_dialogue_instance = dialogue
	
	__ = enter_tween.interpolate_property(cur_dialogue_instance, "rect_position", cur_dialogue_instance.rect_position,
										  Vector2(cur_dialogue_instance.rect_position.x,
										  Utils.screen_height - cur_dialogue_instance.rect_size.y), 1)
	__ = enter_tween.start()
	
	
func _show_current() -> void:
	emit_signal("message_requested")
	var message: String = messages[active_dialogue_offset]
	cur_dialogue_instance.update_message(message)
	
	
func _on_message_completed() -> void:
	emit_signal("message_completed")


func _on_LeaveTween_tween_completed(_object: Object, _key: NodePath):
	cur_dialogue_instance.queue_free()
	emit_signal("finished")


func _on_EnterTween_tween_completed(_object: Object, _key: NodePath) -> void:
	_show_current()
