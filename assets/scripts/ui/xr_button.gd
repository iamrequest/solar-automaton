extends Button

var haptics_hover_intensity = 0.05
var haptics_hover_duration = 0.1

@export var haptics_press_intensity = 0.2
@export var haptics_press_duration = 0.2

@export var audio_player: AudioStreamPlayer3D
@export var sfx_hover: AudioStream
@export var sfx_select: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	
	if(audio_player == null):
		print("Audio player is null! (node: %s)" % get_path())

func _on_mouse_entered() -> void:
	Globals.xr_rig.trigger_haptics(true, haptics_hover_intensity, haptics_hover_duration)
	Globals.xr_rig.trigger_haptics(false, haptics_hover_intensity, haptics_hover_duration)
	
	audio_player.stream = sfx_hover
	audio_player.play()

func _on_pressed() -> void:
	Globals.xr_rig.trigger_haptics(true, haptics_press_intensity, haptics_press_duration)
	Globals.xr_rig.trigger_haptics(false, haptics_press_intensity, haptics_press_duration)
	
	audio_player.stream = sfx_select
	audio_player.play()
