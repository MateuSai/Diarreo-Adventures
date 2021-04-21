extends AnimatedSprite

var coordinates: String = ""

var active: bool = false
var is_player_inside: bool = false
var teleporting: bool = false

var is_menu_opened: bool = false
enum {TELEPORT, MENU, EXIT}
var current_menu_option: int = 0 setget set_current_menu_option

var is_teleport_menu_opened: bool = false
enum {START_POINT, FOREST, CAVE, SHAMAN_TERRITORY}
var current_teleport_menu_option: int = 0 setget set_current_teleport_menu_option

var player: KinematicBody2D = null

onready var menu: NinePatchRect = get_node("CanvasLayer/Menu")
onready var label_container: VBoxContainer = get_node("CanvasLayer/Menu/VBoxContainer")
onready var arrow: AnimatedSprite = get_node("CanvasLayer/Menu/Arrow")

onready var teleport_menu: NinePatchRect = get_node("CanvasLayer/TeleportMenu")
onready var teleport_menu_label_container: VBoxContainer = get_node("CanvasLayer/TeleportMenu/VBoxContainer")
onready var teleport_menu_arrow: AnimatedSprite = get_node("CanvasLayer/TeleportMenu/Arrow")

onready var coins_found: HBoxContainer = get_node("CanvasLayer/CoinsFound")
onready var coins_label: Label = get_node("CanvasLayer/CoinsFound/Label")


func _ready() -> void:
	menu.hide()
	teleport_menu.hide()
	coins_found.hide()
	coordinates = owner.get_name()
	
	_delete_unreached_save_points()
	
	coins_label.text = str(SavedData.coins_collected) + "/4"
	
	
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
				self.current_menu_option -= 1
					
			elif event.is_action_pressed("ui_down"):
				self.current_menu_option += 1
		
		elif event.is_action_pressed("ui_accept"):
			_select_menu_option()
			
	elif is_teleport_menu_opened and not teleporting:
		if event.is_action_pressed("ui_cancel"):
			_close_teleport_menu()
		
		elif event.is_action_pressed("ui_up") or event.is_action_pressed("ui_down"):
			if event.is_action_pressed("ui_up"):
				self.current_teleport_menu_option -= 1
					
			elif event.is_action_pressed("ui_down"):
				self.current_teleport_menu_option += 1
		
		elif event.is_action_pressed("ui_accept"):
			_select_teleport_menu_option()
		
		
func _open_menu() -> void:
	self.current_menu_option = 0
	is_menu_opened = true
	arrow.playing = true
	menu.show()
	coins_found.show()
	
	_immobilize_player()
	
	
func _close_menu() -> void:
	is_menu_opened = false
	arrow.playing = false
	menu.hide()
	coins_found.hide()
	
	_release_player()
	
	
func _open_teleport_menu() -> void:
	self.current_teleport_menu_option = 0
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
			SceneChanger.change_scene_to("res://Menu.tscn")
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
	
	
func set_current_menu_option(new_option: int) -> void:
	current_menu_option = int(clamp(new_option, 0, label_container.get_child_count()-1))
	var current_label: Label = label_container.get_child(current_menu_option)
	arrow.global_position = Vector2(current_label.get_global_position().x - 10,
									current_label.get_global_position().y + current_label.rect_size.y/2)
									
									
func set_current_teleport_menu_option(new_option: int) -> void:
	current_teleport_menu_option = int(clamp(new_option, 0, teleport_menu_label_container.get_child_count()-1))
	var current_label: Label = teleport_menu_label_container.get_child(current_teleport_menu_option)
	teleport_menu_arrow.global_position = Vector2(current_label.get_global_position().x - 10,
											current_label.get_global_position().y + current_label.rect_size.y/2)


func _on_Area2D_player_entered(body: KinematicBody2D) -> void:
	is_player_inside = true
	player = body
	player.hp = player.max_hp
	SavedData.save_data()
	
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


func _on_TeleportLabel_resized() -> void:
	if label_container != null:
		self.current_menu_option = TELEPORT


func _on_StartPointLabel_resized() -> void:
	if teleport_menu_label_container != null:
		self.current_teleport_menu_option = START_POINT
