extends CanvasLayer

var confirmation_dialogue_opened: bool = false

const AVAILABLE_LANGUAGES: Array = ["en", "ca", "es"]
var current_language: int = 0 setget set_current_language

enum {CONTINUE, NEW_GAME, OPTIONS, EXIT}
var current_option: int = CONTINUE setget set_current_option

enum {LANGUAGE, MUSIC, FULL_SCREEN, BACK}
var current_option_option_menu: int = LANGUAGE setget set_current_option_option_menu

var options_menu_opened: bool = false

signal show_confirmation_dialogue()

onready var options_container: VBoxContainer = get_node("VBoxContainer/VBoxContainer")
onready var arrow: AnimatedSprite = get_node("Arrow")

onready var options_menu: NinePatchRect = get_node("OptionsMenu")
onready var options_menu_container: VBoxContainer = get_node("OptionsMenu/VBoxContainer")
onready var music_state_label: Label = get_node("OptionsMenu/VBoxContainer/HBoxContainer2/StateLabel")
onready var full_screen_state_label: Label = get_node("OptionsMenu/VBoxContainer/HBoxContainer3/StateLabel")
onready var options_menu_arrow: AnimatedSprite = get_node("OptionsMenu/Arrow")

onready var music: AudioStreamPlayer = get_node("AudioStreamPlayer")


func _init() -> void:
	SavedData.load_data()
	SavedData.load_menu_data()
	
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	OS.set_window_position(screen_size*0.5 - window_size*0.5)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	current_language = SavedData.current_language
	TranslationServer.set_locale(AVAILABLE_LANGUAGES[current_language])
	
	
func _ready() -> void:
	if not SavedData.game_created:
		options_container.get_node("ContinueLabel").hide()
		
	if not SavedData.music_on:
		music_state_label.text = "Off"
		music.playing = false
		
	if SavedData.full_screen:
		OS.window_fullscreen = true
		full_screen_state_label.text = "On"
		
	self.current_option = 0
	self.current_option_option_menu = 0
	options_menu.hide()
	
	options_menu_container.rect_size.x -= 40
	options_menu_container.rect_position.x += 40
	
	
	
func _input(event: InputEvent) -> void:
	if not confirmation_dialogue_opened:
		if event.is_action_pressed("ui_down"):
			if not options_menu_opened:
				self.current_option += 1
			else:
				self.current_option_option_menu += 1
		elif event.is_action_pressed("ui_up"):
			if not options_menu_opened:
				self.current_option -= 1
			else:
				self.current_option_option_menu -= 1
			
		if event.is_action_pressed("ui_cancel") and options_menu_opened:
			_close_options_menu()
			
		if event.is_action_pressed("ui_accept"):
			if not options_menu_opened:
				match current_option:
					CONTINUE:
						# Load the saved game
						SceneChanger.change_scene_to("res://Game.tscn")
					NEW_GAME:
						# Start a new game and erase the saved data
						if not SavedData.game_created:
							_start_new_game()
						else:
							confirmation_dialogue_opened = true
							emit_signal("show_confirmation_dialogue")
					OPTIONS:
						_open_options_menu()
					EXIT:
						get_tree().quit()
			else:
				match current_option_option_menu:
					LANGUAGE:
						self.current_language += 1
					MUSIC:
						if music_state_label.text == "On":
							music_state_label.text = "Off"
							SavedData.music_on = false
						else:
							music_state_label.text = "On"
							SavedData.music_on = true
						music.playing = SavedData.music_on
					FULL_SCREEN:
						if full_screen_state_label.text == "On":
							full_screen_state_label.text = "Off"
							SavedData.full_screen = false
							OS.window_fullscreen = false
						else:
							full_screen_state_label.text = "On"
							SavedData.full_screen = true
							OS.window_fullscreen = true
					BACK:
						_close_options_menu()
				
				
func _open_options_menu() -> void:
	self.current_option_option_menu = 0
	options_menu_opened = true
	options_menu.show()
	
	
func _close_options_menu() -> void:
	SavedData.save_menu_data()
	options_menu_opened = false
	options_menu.hide()
	
	
func set_current_option(new_option: int) -> void:
	if SavedData.game_created:
		current_option = int(clamp(new_option, 0, options_container.get_child_count()-1))
	else:
		current_option = int(clamp(new_option, 1, options_container.get_child_count()-1))
	arrow.position = options_container.get_child(current_option).rect_global_position + Vector2(-10,
											options_container.get_child(current_option).rect_size.y/2)
											
											
func set_current_option_option_menu(new_option: int) -> void:
	current_option_option_menu = int(clamp(new_option, 0, options_menu_container.get_child_count()-1))
	options_menu_arrow.global_position = (
								options_menu_container.get_child(current_option_option_menu).rect_global_position +
								Vector2(-10, options_menu_container.get_child(current_option_option_menu).rect_size.y/2))
								
								
func set_current_language(_new_value: int) -> void:
	current_language += 1
	if current_language > AVAILABLE_LANGUAGES.size() - 1:
		current_language = 0
	SavedData.current_language = current_language
	TranslationServer.set_locale(AVAILABLE_LANGUAGES[current_language])
											
											
func _on_ContinueLabel_resized() -> void:
	if options_container != null and SavedData.game_created:
		self.current_option = 0


func _on_NewGameLabel_resized():
	if options_container != null and not SavedData.game_created:
		self.current_option = 1


func _on_ConfirmationDialogue_start_new_game() -> void:
	_start_new_game()
	
	
func _start_new_game() -> void:
	SavedData.restore_default_data()
	SavedData.game_created = true
	SavedData.save_data()
	SavedData.save_menu_data()
	SceneChanger.change_scene_to("res://Game.tscn")


func _on_ConfirmationDialogue_closed() -> void:
	confirmation_dialogue_opened = false
