extends OvaniPlayer

@export_category("Pause")
var pre_pause_volume:= 0.0
var pre_pause_intensity:= 0.0
@export var pause_volume := -1.0
@export var pause_intensity := 0.0
@export var pause_fade_duration := .3
@export var pause_unfade_duration := 0.3

@export_category("On Level Failed")
@export var level_failed_bgm : OvaniSong
@export var level_failed_fade_duration:= 1.0
@export var level_failed_intensity:= 0.75
@export var level_failed_volume:= 0.75

@export_category("On Level Complete")
@export var level_complete_bgm : OvaniSong
@export var level_complete_fade_duration:= 1.0
@export var level_complete_intensity:= 0.75
@export var level_complete_volume:= 0.75

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	%GameManager.on_level_completed.connect(_on_level_completed)
	%GameManager.on_level_failed.connect(_on_level_failed)
	%GameManager.on_paused.connect(_on_paused)
	%GameManager.on_unpaused.connect(_on_unpaused)

func _on_level_completed() -> void:
	transition_audio(level_complete_bgm, level_complete_intensity, level_complete_volume, level_complete_fade_duration)
	
func _on_level_failed() -> void:
	transition_audio(level_failed_bgm, level_failed_intensity, level_failed_volume, level_failed_fade_duration)

func transition_audio(song: OvaniSong, intensity: float, volume: float, fade_duration: float) -> void:
	PlaySongNow(song, fade_duration)
	FadeIntensity(intensity, fade_duration)
	FadeVolume(volume, fade_duration)

func _on_paused() -> void:
	pre_pause_volume = Volume
	pre_pause_intensity = Intensity
	FadeVolume(pause_volume, pause_fade_duration)
	FadeIntensity(pause_intensity, pause_fade_duration)
	block_pause_spam()
	
func _on_unpaused() -> void:
	FadeVolume(pre_pause_volume, pause_unfade_duration)
	FadeIntensity(pre_pause_intensity, pause_unfade_duration)
	block_pause_spam()

func block_pause_spam() -> void:
	# Block re-pausing for a short duration so BGM volume/intensity tweening doesn't break
	%GameManager.can_toggle_pause = false
	await get_tree().create_timer(pause_unfade_duration).timeout
	%GameManager.can_toggle_pause = true
