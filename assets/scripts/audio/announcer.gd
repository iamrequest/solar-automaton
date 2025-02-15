extends AudioStreamPlayer3D

@export var sfx_ready : AudioStream
@export var sfx_3 : AudioStream
@export var sfx_2 : AudioStream
@export var sfx_1 : AudioStream
@export var sfx_go : AudioStream

@export var sfx_level_completed : AudioStream
@export var sfx_level_failed : AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%GameManager.on_level_completed.connect(_on_level_completed)
	%GameManager.on_level_failed.connect(_on_level_failed)
	
	play_sfx(sfx_ready)
	$Timer.start(1.5)
	await $Timer.timeout
	
	#play_sfx(sfx_3)
	#$Timer.start(1.0)
	#await $Timer.timeout
	#
	#play_sfx(sfx_2)
	#$Timer.start(1.0)
	#await $Timer.timeout
	#
	#play_sfx(sfx_1)
	#$Timer.start(1.0)
	#await $Timer.timeout
	
	play_sfx(sfx_go)
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS	

func _on_level_completed() -> void:
	play_sfx(sfx_level_completed)
	
func _on_level_failed() -> void:
	play_sfx(sfx_level_failed)

func play_sfx(new_stream: AudioStream):
	stream = new_stream
	play()
