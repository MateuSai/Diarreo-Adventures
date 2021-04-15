extends Area2D
class_name Collectable

const AUDIO_RANDOMIZER: Reference = preload("res://UI/AudioRandomizer.gd")

export(bool) var fade_after_collect: bool = true

export(AudioStreamSample) var sound: AudioStreamSample = preload("res://Sounds/CollectableSound.wav")

onready var parent: Node2D = get_parent()


func _init() -> void:
	set_collision_layer_bit(0, false)
	set_collision_mask_bit(0, false)
	
	set_collision_mask_bit(1, true)


func _ready() -> void:
	var __ = connect("body_entered", parent, "_on_player_collect")
	__ = connect("body_entered", self, "_on_player_collect")
	
	
func _on_player_collect(_body: Node2D) -> void:
	if fade_after_collect:
		var tween: Tween = Tween.new()
		var __ = tween.interpolate_property(parent, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.5, Tween.TRANS_SINE,
											Tween.EASE_OUT)
		__ = tween.connect("tween_completed", self, "_on_tween_completed")
		parent.add_child(tween)
		__ = tween.start()
		
	var audio: AudioStreamPlayer = AudioStreamPlayer.new()
	audio.set_script(AUDIO_RANDOMIZER)
	audio.volume_db = -5
	audio.stream = sound
	parent.add_child(audio)
	audio.play()
	
	
func _on_tween_completed(_object: Object, _key: NodePath) -> void:
	parent.queue_free()
