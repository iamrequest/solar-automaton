extends PlayerTriggerArea

#@export var volume := 1.0
#@export var set_intensity := true
@export_range(0, 1) var intensity := 1.0
@export_range(0, 10) var fade_duration := 1.0

# TODO: Implement as needed
#@export var set_new_song := false
#@export var new_song: OvaniSong

func on_player_entered():
	super()
	var bgm_manager = (Globals.game_manager.bgm_manager as BGMManager)
	if(bgm_manager):
		bgm_manager.FadeIntensity(intensity, fade_duration)
	else:
		print("Missing BGM manager reference")
