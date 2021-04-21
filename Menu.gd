extends CanvasLayer

enum {CONTINUE, NEW_GAME, OPTIONS, EXIT}
var current_option: int = CONTINUE setget set_current_option

onready var options_container: VBoxContainer = get_node("VBoxContainer/VBoxContainer")
onready var arrow: AnimatedSprite = get_node("Arrow")


func _init() -> void:
	SavedData.load_data()
	
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	#TranslationServer.set_locale("ca")
	
	
func _ready() -> void:
	self.current_option = 0
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		self.current_option += 1
	elif event.is_action_pressed("ui_up"):
		self.current_option -= 1
		
	if event.is_action_pressed("ui_accept"):
		match current_option:
			CONTINUE:
				# Load the saved game
				SceneChanger.change_scene_to("res://Game.tscn")
			NEW_GAME:
				# Start a new game and erase the saved data
				SavedData.restore_default_data()
				SavedData.save_data()
				SceneChanger.change_scene_to("res://Game.tscn")
			OPTIONS:
				pass
			EXIT:
				get_tree().quit()
	
	
func set_current_option(new_option: int) -> void:
	current_option = int(clamp(new_option, 0, options_container.get_child_count()-1))
	arrow.position = options_container.get_child(current_option).rect_global_position + Vector2(-10,
											options_container.get_child(current_option).rect_size.y/2)
											
											
func _on_ContinueLabel_resized() -> void:
	if options_container != null:
		self.current_option = CONTINUE
