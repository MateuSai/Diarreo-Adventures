extends NinePatchRect

enum {YES, NO}
var current_option: int = 0 setget set_current_option

signal start_new_game()
signal closed()

onready var options_container: HBoxContainer = get_node("VBoxContainer/HBoxContainer")
onready var arrow: AnimatedSprite = get_node("Arrow")


func _ready() -> void:
	hide()


func _input(event: InputEvent) -> void:
	if is_visible_in_tree():
		if event.is_action_pressed("ui_right"):
			self.current_option += 1
		elif event.is_action_pressed("ui_left"):
			self.current_option -= 1
			
		if event.is_action_pressed("ui_accept"):
			match current_option:
				YES:
					emit_signal("start_new_game")
				NO:
					hide()
					yield(get_tree().create_timer(0.5), "timeout")
					emit_signal("closed")
		


func set_current_option(new_value: int) -> void:
	current_option = int(clamp(new_value, 0, options_container.get_child_count()-1))
	arrow.global_position = options_container.get_child(current_option).rect_global_position + Vector2(-10,
														options_container.get_child(current_option).rect_size.y/2)


func _on_Menu_show_confirmation_dialogue() -> void:
	self.current_option = 0
	show()


func _on_Label_resized() -> void:
	if options_container != null:
		self.current_option = 0
