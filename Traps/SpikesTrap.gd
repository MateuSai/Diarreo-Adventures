extends KinematicBody2D

var damage: int = 1

var direction: Vector2 = Vector2.DOWN
var speed: int = 250

var collided: bool = false
signal collided(spikes)

onready var hitbox: Area2D = get_node("HitBox")
onready var dust: AnimatedSprite = get_node("Dust")


func _ready() -> void:
	direction = direction.rotated(rotation)
	if direction.x == -1:
		hitbox.direction = -1
	
	
func _physics_process(delta: float) -> void:
	if not collided:
		var collision: KinematicCollision2D = move_and_collide(direction * speed * delta)
		if collision:
			collided = true
			dust.frame = 0
			dust.play()
			emit_signal("collided", self)

