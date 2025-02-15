extends AudioStreamPlayer3D

@export var sfx: Array[AudioStream] 
@export_range(-1.0, 2.0) var pitch_scale_base := 1.0
@export_range(0.0, 1.0) var pitch_scale_variance := 0.1

func _ready() -> void:
	randomize()
	
func play_random_sfx() -> void:
	stream = sfx.pick_random()
	pitch_scale = pitch_scale_base + randf_range(-pitch_scale_variance, pitch_scale_variance)
	play()
