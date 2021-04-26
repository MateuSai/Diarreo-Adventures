extends Control

enum {CONTINUE, MENU, EXIT}
var option: int = CONTINUE setget set_option

var is_paused: bool = false

onready var options_container: VBoxContainer = get_node("VBoxContainer")
onready var arrow: AnimatedSprite = get_node("Arrow")
onready var color_rect: ColorRect = get_node("ColorRect")


func _ready() -> void:
	options_container.hide()
	arrow.hide()
	arrow.playing = false
	color_rect.color.a = 0.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_pause") and Utils.can_pause:
		_change_pause_state()
		
	if is_paused:
		if event.is_action_pressed("ui_down"):
			self.option += 1
		elif event.is_action_pressed("ui_up"):
			self.option -= 1
						
		if event.is_action_pressed("ui_accept"):
			_select_option()
		
		
func _change_pause_state() -> void:
	is_paused = not is_paused
	get_tree().paused = is_paused
	arrow.playing = is_paused
	
	if is_paused:
		self.option = CONTINUE
		options_container.show()
		arrow.show()
		color_rect.color.a = 0.35
	else:
		options_container.hide()
		arrow.hide()
		color_rect.color.a = 0.0
		
		
func _select_option() -> void:
	match option:
		CONTINUE:
			_change_pause_state()
		MENU:
			# Go to the main menu
			_change_pause_state()
			SceneChanger.change_scene_to("res://Menu.tscn")
		EXIT:
			get_tree().quit()
			
			
func set_option(new_option: int) -> void:
	option = int(clamp(new_option, 0, options_container.get_child_count()-1))
	arrow.position = (options_container.get_child(option).rect_global_position +
					  Vector2(-10, options_container.get_child(option).rect_size.y/2))



func _on_ContinueButton_resized() -> void:
	if options_container != null:
		self.option = CONTINUE
