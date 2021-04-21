extends Node

const SAVED_DATA_FILE_PATH: String = "user://data.save"

var first_game: bool = false

var first_meat_eaten: bool = false
var first_apple_eaten: bool = false
var pre_final_battle_dialogue_watched: bool = false

var player_stats: Dictionary = {
	'max_hp': 2,
	'max_air_jumps': 1
}

var save_points: Dictionary = {
	'start_point': {'coor': Vector2.ZERO, 'pos': Vector2(56, 87), 'available': true},
	'forest': {'coor': Vector2(2,-1), 'pos': Vector2(59, 151), 'available': true},
	'cave': {'coor': Vector2(0,2), 'pos': Vector2(34, 120), 'available': true},
	'shaman_territory': {'coor': Vector2(-3, 0), 'pos': Vector2(145, 102), 'available': true}
}
var last_save_point: Dictionary = save_points.start_point

var chests_opened: Dictionary = {
	'1,-1': false,
	'-1,-1': false,
	'1,2': false,
	'1,1': false,
	'2,2': false,
	'-2,0': false,
	'-3,-1': false,
	'-2,-1': false,
	'3,-2': false
}

var levers_turned: Dictionary = {
	'-1,0': true,
	'1,0': false,
	'2,-1': false,
	'-1,1': false,
	'1,2': false,
	'-3,0': true
}

var coins_collected: int = 0


func change_last_save_point(coor: Vector2) -> void:
	for save_point in save_points.values():
		if save_point.coor == coor:
			last_save_point = save_point
			return
			
	printerr("Unexistent save point")
	
	
func save_data() -> void:
	var data: Dictionary = {
		'first_game': first_game,
		'first_meat_eaten': first_meat_eaten,
		'first_apple_eaten': first_apple_eaten,
		'player_stats': player_stats,
		'save_points': save_points,
		'last_save_point': last_save_point,
		'chests_opened': chests_opened,
		'levers_turned': levers_turned,
		'coins_collected': coins_collected
	}
	
	var file: File = File.new()
	var __ = file.open(SAVED_DATA_FILE_PATH, File.WRITE)
	file.store_var(data)
	file.close()
	
	
func load_data() -> void:
	var file: File = File.new()
	if file.file_exists(SAVED_DATA_FILE_PATH):
		var __ = file.open(SAVED_DATA_FILE_PATH, File.READ)
		var data: Dictionary = file.get_var()
		file.close()
		
		first_game = data.first_game
		first_meat_eaten = data.first_meat_eaten
		first_apple_eaten = data.first_apple_eaten
		player_stats = data.player_stats
		save_points = data.save_points
		last_save_point = data.last_save_point
		chests_opened = data.chests_opened
		levers_turned = data.levers_turned
		coins_collected = data.coins_collected
		
		
func restore_default_data() -> void:
	first_game = true
	first_meat_eaten = false
	first_apple_eaten = false
	
	player_stats = {
		'max_hp': 2,
		'max_air_jumps': 0
	}
	
	save_points = {
		'start_point': {'coor': Vector2.ZERO, 'pos': Vector2(56, 87), 'available': true},
		'forest': {'coor': Vector2(2,-1), 'pos': Vector2(59, 151), 'available': true},
		'cave': {'coor': Vector2(0,2), 'pos': Vector2(34, 120), 'available': true},
		'shaman_territory': {'coor': Vector2(-3, 0), 'pos': Vector2(145, 102), 'available': true}
	}
	last_save_point = save_points.start_point
	
	chests_opened = {
		'1,-1': false,
		'-1,-1': false,
		'1,2': false,
		'1,1': false,
		'2,2': false,
		'-2,0': false,
		'-3,-1': false,
		'-2,-1': false,
		'3,-2': false
	}
	
	levers_turned = {
		'-1,0': false,
		'1,0': false,
		'2,-1': false,
		'-1,1': false,
		'1,2': false,
		'-3,0': false
	}
	
	coins_collected = 0
