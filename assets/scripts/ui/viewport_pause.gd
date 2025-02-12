extends ViewportBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	toggle(false)
	%GameManager.on_paused.connect(_on_pause)
	%GameManager.on_unpaused.connect(_on_unpause)

func _on_pause():
	toggle(true)

func _on_unpause():
	toggle(false)
