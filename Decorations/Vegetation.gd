extends Sprite
class_name Vegetation, "res://platform_metroidvania asset pack v1.01/miscellaneous sprites/grass_props.png"

const POSSIBLE_SPRITES: Array = [
	preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/grass_props.png"),
	preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/flowers_props.png"),
	preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/drygrass_props.png"),
	preload("res://platform_metroidvania asset pack v1.01/miscellaneous sprites/bigflowers_props.png")
]


func _init() -> void:
	texture = POSSIBLE_SPRITES[randi() % POSSIBLE_SPRITES.size()]

