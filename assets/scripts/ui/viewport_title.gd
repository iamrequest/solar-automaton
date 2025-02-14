extends ViewportBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	toggle(true)
	Globals.xr_rig.toggle_laser(true)

func _on_pause():
	toggle(true)

func _on_unpause():
	toggle(false)
