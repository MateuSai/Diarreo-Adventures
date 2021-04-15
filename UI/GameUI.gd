extends CanvasLayer

onready var game_over_label: RichTextLabel = get_node("GameOver/GameOverLabel")
onready var game_over_tween: Tween = get_node("GameOver/GameOverLabel/GameOverTween")
onready var game_over_timer: Timer = get_node("GameOver/GameOverTimer")
onready var game_over_sound: AudioStreamPlayer = get_node("GameOver/GameOverSound")

onready var dialogue_manager: Control = get_node("DialogueManager")


func _ready() -> void:
	game_over_label.modulate.a = 0.0
	
	
func _game_over() -> void:
	game_over_sound.play()
	
	var duration: float = 0.9
	var __ = game_over_tween.interpolate_property(game_over_label, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1),
												  duration, Tween.TRANS_CIRC, Tween.EASE_IN)
	__ = game_over_tween.start()
	
	game_over_timer.wait_time = duration + 1
	game_over_timer.start()


func _on_GameOverTimer_timeout() -> void:
	SceneChanger.change_scene_to("res://Game.tscn")
	
	
func show_messages(message_list: Array) -> void:
	dialogue_manager.show_messages(message_list)


func _on_FadeScreen_screen_faded_in() -> void:
	var __ = get_tree().reload_current_scene()
