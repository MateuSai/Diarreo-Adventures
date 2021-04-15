extends TileMap

const RABBIT_SCENE: PackedScene = preload("res://Fauna/Rabbit.tscn")
const TORCH_SCENE: PackedScene = preload("res://Decorations/TikiTorch.tscn")

var horizontal_tiles: int = ceil(Utils.screen_width/float(Utils.tile_size))
var vertical_tiles: int = ceil(Utils.screen_height/float(Utils.tile_size))


func _enter_tree() -> void:
	for x in horizontal_tiles:
		for y in range(1, vertical_tiles):
			var current_cell: int = get_cell(x, y)
			if get_cell(x, y - 1) == -1 and (current_cell == 0 or current_cell == 1 or current_cell == 2):
				if randi() % 8 == 0:
					var vegetation: Vegetation = Vegetation.new()
					vegetation.position = Vector2(x * Utils.tile_size + Utils.tile_size/2.0, y * Utils.tile_size - 3)
					add_child(vegetation)
					
				if randi() % 35 == 0:
					var rabbit: KinematicBody2D = RABBIT_SCENE.instance()
					rabbit.position = Vector2(x * Utils.tile_size + Utils.tile_size/2.0,
											  y * Utils.tile_size - Utils.tile_size/2.0)
					add_child(rabbit)
			elif get_cell(x, y - 1) == -1 and (current_cell == 3 or current_cell == 4):
				if randi() % 20 == 0:
					var torch: AnimatedSprite = TORCH_SCENE.instance()
					torch.position = Vector2(x * Utils.tile_size + Utils.tile_size/2.0,
											  y * Utils.tile_size - Utils.tile_size/2.0 - 3)
					add_child(torch)

