extends AudioStreamPlayer
class_name AudioRandomizer


func play(from_position: float = 0.0) -> void:
	pitch_scale = rand_range(0.95, 1.05)
	.play(from_position)
