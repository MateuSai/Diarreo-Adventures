extends AnimatedSprite

var coordinates: String = ""

var active: bool = false
var is_player_inside: bool = false
var teleporting: bool = false

var is_menu_opened: bool = false
enum {TELEPORT, MENU, EXIT}
var current_menu_option: int = 0

var is_teleport_menu_opened: bool = false
enum {START_POINT, FOREST, CAVE, SHAMAN_TERRITORY}
var current_teleport_menu_option: int = 0

var player: KinematicBody2D = null

onready var menu: NinePatchRect = get_node("CanvasLayer/Menu")
onready var label_container: VBoxContainer = get_node("CanvasLayer/Menu/VBoxContainer")
onready var arrow: AnimatedSprite = get_node("CanvasLayer/Menu/Arrow")

onready var teleport_menu: NinePatchRect = get_node("CanvasLayer/TeleportMenu")
onready var teleport_menu_label_container: VBoxContainer = get_node("CanvasLayer/TeleportMenu/VBoxContainer")
onready var teleport_menu_arrow: AnimatedSprite = get_node("CanvasLayer/TeleportMenu/Arrow")


func _ready() -> void:
	menu.hide()
	teleport_menu.hide()
	coordinates = owner.get_name()
	
	_delete_unreached_save_points()
	
	var current_label: Label = label_container.get_child(current_menu_option)
	arrow.global_position = Vector2(current_label.get_global_position().x - 10,
									current_label.get_global_position().y + current_label.rect_size.y/2)
	
	current_label = teleport_menu_label_container.get_child(current_teleport_menu_option)
	teleport_menu_arrow.global_position = Vector2(current_label.get_global_position().x - 10,
												  current_label.get_global_position().y + current_label.rect_size.y/2)
												
	
	
func _delete_unreached_save_points() -> void:
	for i in SavedData.save_points.size():
		if not SavedData.save_points.values()[i].available:
			teleport_menu_label_container.get_child(i).queue_free()
	
	
func _input(event: InputEvent) -> void:
	if is_player_inside and event.is_action_pressed("ui_select") and not teleporting:
		if is_menu_opened and not is_teleport_menu_opened:
			_close_menu()
		else:
			_open_menu()
			
	if is_menu_opened and not is_teleport_menu_opened and not teleporting:
		if event.is_action_pressed("ui_cancel"):
			_close_menu()
		
		elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			if event.is_action_pressed("ui_up"):
				current_menu_option -= 1
				if current_menu_option < 0:
					current_menu_option = label_container.get_child_count()-1
					
			elif event.is_action_pressed("ui_down"):
				current_menu_option += 1
				if current_menu_option > label_container.get_child_count()-1:
					current_menu_option = 0
					
			var current_label: Label = label_container.get_child(current_menu_option)
			arrow.global_position = Vector2(current_label.get_global_position().x - 10,
											current_label.get_global_position().y + current_label.rect_size.y/2)
		
		elif event.is_action_pressed("ui_accept"):
			_select_menu_option()
			
	elif is_teleport_menu_opened and not teleporting:
		if event.is_action_pressed("ui_cancel"):
			_close_teleport_menu()
		
		elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			if event.is_action_pressed("ui_up"):
				current_teleport_menu_option -= 1
				if current_teleport_menu_option < 0:
					current_teleport_menu_option = teleport_menu_label_container.get_child_count()-1
					
			elif event.is_action_pressed("ui_down"):
				current_teleport_menu_option += 1
				if current_teleport_menu_option > teleport_menu_label_container.get_child_count()-1:
					current_teleport_menu_option = 0
					
			var current_label: Label = teleport_menu_label_container.get_child(current_teleport_menu_option)
			teleport_menu_arrow.global_position = Vector2(current_label.get_global_position().x - 10,
											current_label.get_global_position().y + current_label.rect_size.y/2)
		
		elif event.is_action_pressed("ui_accept"):
			_select_teleport_menu_option()
		
		
func _open_menu() -> void:
	is_menu_opened = true
	arrow.playing = true
	menu.show()
	
	_immobilize_player()
	
	
func _close_menu() -> void:
	is_menu_opened = false
	arrow.playing = false
	menu.hide()
	
	_release_player()
	
	
func _open_teleport_menu() -> void:
	is_teleport_menu_opened = true
	teleport_menu_arrow.playing = true
	teleport_menu.show()
	
	
func _close_teleport_menu() -> void:
	is_teleport_menu_opened = false
	teleport_menu_arrow.playing = false
	teleport_menu.hide()
	
	
func _select_menu_option() -> void:
	match current_menu_option:
		TELEPORT:
			_open_teleport_menu()
		MENU:
			print("menu option selected")
		EXIT:
			get_tree().quit()
			
			
func _select_teleport_menu_option() -> void:
	match current_teleport_menu_option:
		START_POINT:
			_teleport_player(SavedData.save_points.start_point)
		FOREST:
			_teleport_player(SavedData.save_points.forest)
		CAVE:
			_teleport_player(SavedData.save_points.cave)
		SHAMAN_TERRITORY:
			_teleport_player(SavedData.save_points.shaman_territory)
			
			
func _teleport_player(new_save_point: Dictionary) -> void:
	SavedData.last_save_point = new_save_point
	_close_teleport_menu()
	_close_menu()
	owner.get_parent().get_parent().teleport_player()
	
	
func _immobilize_player() -> void:
	player.can_move = false
	player.can_attack = false
	
	
func _release_player() -> void:
	player.can_move = true
	player.can_attack  = true


func _on_Area2D_player_entered(body: KinematicBody2D) -> void:
	is_player_inside = true
	player = body
	
	if not active:
		if player.last_save_point != null:
			player.last_save_point.play("default")
		player.last_save_point = self
		
		var int_coordinates: PoolStringArray = coordinates.split(",")
		var coor: Vector2 = Vector2(int(int_coordinates[0]), int(int_coordinates[1]))
		SavedData.change_last_save_point(coor)
		
		play("active")


func _on_Area2D_player_exited(_player: KinematicBody2D) -> void:
	is_player_inside = false
	_close_menu()