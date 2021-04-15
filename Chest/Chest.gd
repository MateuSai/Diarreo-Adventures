extends AnimatedSprite

export(PackedScene) var object_scene: PackedScene = null

var coordinates: String = ""

var is_player_inside: bool = false
var is_opened: bool = false

onready var animation_player: AnimationPlayer = get_node("AnimationPlayer")
onready var tween: Tween = get_node("Tween")


func _ready() -> void:
	assert(object_scene != null)
	
	coordinates = owner.get_name()
	if SavedData.chests_opened[coordinates]:
		is_opened = true
		animation = "open"
		frame = 5
	else:
		animation_player.play("idle")
	
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_interact") and is_player_inside and not is_opened:
		is_opened = true
		animation_player.play("open")
		
		
func _drop_object() -> void:
	var object: Node2D = object_scene.instance()
	owner.get_node("Objects").add_child(object)
	
	var __ = tween.interpolate_property(object, "position", position, position + Vector2(0, -5), 0.3, Tween.TRANS_QUAD,
							   Tween.EASE_OUT)
	__ = tween.start()
	
	yield(tween, "tween_completed")
	
	__ = tween.interpolate_property(object, "position", position + Vector2(0, -5), position, 0.3, Tween.TRANS_SINE,
							   Tween.EASE_IN)
	__ = tween.start()


func _on_Area2D_player_entered(_player: KinematicBody2D) -> void:
	is_player_inside = true


func _on_Area2D_player_exited(_player: KinematicBody2D) -> void:
	is_player_inside = false
