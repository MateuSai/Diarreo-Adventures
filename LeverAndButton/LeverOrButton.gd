extends Area2D
class_name LeverOrButton

export(int) var link_code: int = 0
signal activated()

onready var actionables_container: Node2D = owner.get_node("Actionables")
onready var sprite: Sprite = get_node("Sprite")


func _ready() -> void:
	if link_code != 0:
		for actionable in actionables_container.get_children():
			if actionable.link_code == link_code:
				var __ = connect("activated", actionable, "_change_state")

