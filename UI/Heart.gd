extends TextureRect

const TEXTURES: Dictionary = {
	"full": preload("res://platform_metroidvania asset pack v1.01/hud elements/hearts_hud.png"),
	"empty": preload("res://platform_metroidvania asset pack v1.01/hud elements/no_hearts_hud.png")
}

var is_full: bool = true

onready var destroy_animation: AnimatedSprite = get_node("DestroyAnimation")


func _ready() -> void:
	recover_heart()


func recover_heart() -> void:
	is_full = true
	self_modulate = Color(1, 1, 1, 0)
	destroy_animation.show()
	destroy_animation.play("default", true)


func destroy_heart() -> void:
	is_full = false
	destroy_animation.show()
	destroy_animation.play("default")
	texture = TEXTURES.empty
	self_modulate = Color(1, 1, 1, 1)


func _on_DestroyAnimation_animation_finished() -> void:
	destroy_animation.playing = false
	destroy_animation.hide()
	if is_full:
		texture = TEXTURES.full
		self_modulate = Color(1, 1, 1, 1)
