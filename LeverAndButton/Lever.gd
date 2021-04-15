extends LeverOrButton

const TEXTURES: Dictionary = {
	'right': preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/lever_turned_right.png"),
	'left': preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/lever_turned_left.png")
}

var facing: int = 1


func _ready() -> void:
	if SavedData.levers_turned[owner.name]:
		turn_lever(-1)


func turn_lever(direction: int) -> void:
	if facing == direction:
		return
		
	facing = direction
	emit_signal("activated")
	if facing == 1:
		sprite.texture = TEXTURES.right
	else:
		sprite.texture = TEXTURES.left

