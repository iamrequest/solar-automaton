extends ViewportBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	toggle(false)
	%GameManager.on_paused.connect(_on_pause)
	%GameManager.on_unpaused.connect(_on_unpause)
	Globals.xr_rig.get_non_dominant_hand().button_pressed.connect(on_non_dominant_input_pressed)

func _on_pause():
	toggle(false)

func _on_unpause():
	toggle(false)

# TODO: Untested
func on_non_dominant_input_pressed(name: String):
	match name:
		"ax_button":
			%GameManager.pause
		"by_button":
			%GameManager.pause
