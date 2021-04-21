extends Node2D

const DIRECTIONS: Array = [Vector2.LEFT, Vector2.UP, Vector2.RIGHT, Vector2.DOWN]

var start_point: Vector2 = SavedData.last_save_point.coor

var levels_directory: Directory = Directory.new()
var levels_in_scene_tree: Array = []

var player_position: Vector2 = start_point
var camera_position: Vector2 = Vector2.ZERO

enum {FOREST, CAVE}
var music_type: int = 0

onready var levels: Node2D = get_node("Levels")
onready var player: KinematicBody2D = get_node("Player")
onready var camera: Camera2D = get_node("Camera2D")
onready var camera_tween: Tween = get_node("Camera2D/Tween")
onready var UI: CanvasLayer = get_node("UI")
onready var music: AudioStreamPlayer = get_node("Music")


func _ready() -> void:
	assert(levels_directory.open("res://Levels") == OK)
	var __ = player.connect("killed", UI, "_game_over")
	
	_spawn_level(start_point)
	_check_zone(start_point)
	
	_load_near_levels(start_point)
	
	player.position = SavedData.last_save_point.pos
	
	if SavedData.first_game:
		SavedData.first_game = false
		_show_first_time_dialogue()
		
		
func _load_near_levels(center_pos: Vector2) -> void:
	for direction in DIRECTIONS:
		var level_pos: Vector2 = center_pos + direction
		_spawn_level(level_pos)
		
		
func _spawn_level(pos: Vector2) -> void:
	var level_coordinates: String = str(pos.x) + "," + str(pos.y)
	if _is_in_levels_directory(level_coordinates + ".tscn") and not _is_in_scene_tree(level_coordinates):
		var level: Node2D = load("res://Levels/" + level_coordinates + ".tscn").instance()
		level.position = Vector2((pos.x - start_point.x) * Utils.screen_width, (pos.y - start_point.y) * Utils.screen_height)
		levels.call_deferred("add_child", level)
		levels_in_scene_tree.append(level_coordinates)
		
		
func _delete_level(pos: Vector2) -> void:
	var level_coordinates: String = str(pos.x) + "," + str(pos.y)
	if _is_in_scene_tree(level_coordinates):
		levels.get_node(level_coordinates).queue_free()
		levels_in_scene_tree.erase(level_coordinates)
		
		
func _is_in_levels_directory(level_name: String) -> bool:
	var __ = levels_directory.list_dir_begin()
	var file_name = levels_directory.get_next()
	while file_name != "":
		if file_name == level_name:
			return true
		file_name = levels_directory.get_next()
	return false
	
	
func _is_in_scene_tree(coordinates: String) -> bool:
	for level_coordinates in levels_in_scene_tree:
		if level_coordinates == coordinates:
			return true
	return false
	
	
func _show_first_time_dialogue() -> void:
	_immobiliza_player()
	yield(get_tree().create_timer(1.1), "timeout")
	UI.show_messages([" {p=3.0} " + tr("string_introductory_dialogue_1"), tr("string_introductory_dialogue_2"),
					 tr("string_introductory_dialogue_3")])
	yield(get_tree().create_timer(1), "timeout")
	_play_constipation_sound()
	yield(get_tree().create_timer(1), "timeout")
	_play_constipation_sound()
	yield(get_tree().create_timer(1), "timeout")
	_play_constipation_sound()
	
	
func show_first_meat_eaten_dialogue() -> void:
	_immobiliza_player()
	yield(get_tree().create_timer(0.4), "timeout")
	UI.show_messages([tr("string_meat_dialogue")])
	yield(get_tree().create_timer(4.0), "timeout")
	_play_constipation_sound()
	
	
func show_first_apple_eaten_dialogue() -> void:
	_immobiliza_player()
	yield(get_tree().create_timer(0.4), "timeout")
	UI.show_messages([tr("string_apple_dialogue")])
	yield(get_tree().create_timer(2.0), "timeout")
	_play_constipation_sound()
	
	
func _show_pre_final_battle_dialogue() -> void:
	_immobiliza_player()
	yield(get_tree().create_timer(0.4), "timeout")
	UI.show_messages([tr("string_pre_final_battle_dialogue")])
	music.stream = load("res://Music/battleThemeA.ogg")
	music.volume_db = -5
	music.play()
	
	
func _play_constipation_sound() -> void:
	var sound: AudioStreamPlayer = AudioStreamPlayer.new()
	sound.stream = preload("res://Sounds/burp.wav")
	sound.volume_db = 8
	sound.set_script(preload("res://UI/AudioRandomizer.gd"))
	add_child(sound)
	sound.play()
	
	yield(sound, "finished")
	
	sound.queue_free()
	
	
func _immobiliza_player() -> void:
	player.can_move = false
	player.can_attack = false
	
	
func _release_player() -> void:
	player.can_move = true
	player.can_attack = true


func _on_player_exit_camera(_body: KinematicBody2D, direction: Vector2):
	for dir in DIRECTIONS:
		if dir != direction:
			_delete_level(player_position + dir)
	player_position += direction
	_load_near_levels(player_position)
	
	_check_zone(player_position)
	
	camera_position += direction * Vector2(Utils.screen_width, Utils.screen_height)
	var __ = camera_tween.interpolate_property(camera, "position", camera.position, camera_position, 0.5,
		Tween.TRANS_SINE, Tween.EASE_OUT)
	__ = camera_tween.start()
	
	
func _check_zone(coor: Vector2) -> void:
	if coor.y > 0 and music_type != CAVE:
		music_type = CAVE
		music.stream = load("res://Music/8BitCave.ogg")
		music.volume_db = 0
		music.play()
	elif coor.y <= 0 and music_type != FOREST:
		music_type = FOREST
		music.stream = load("res://Music/TheForest.ogg")
		music.volume_db = 7
		music.play()


func teleport_player() -> void:
	player.teleport()
	SceneChanger.change_scene_to("res://Game.tscn")


func _on_LeaveTween_tween_completed(_object: Object, _key: NodePath) -> void:
	_release_player()
