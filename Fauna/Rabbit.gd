extends GroundEnemy


func _init() -> void:
	speed = (randi() % 20) + 20
	
	
func _ready() -> void:
	state_machine.set_state(randi() % state_machine.states.size())
	
	
func _physics_process(_delta: float) -> void:
	velocity.x = direction * speed
