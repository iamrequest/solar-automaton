extends ViewportBase

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	toggle(false)
	%GameManager.on_level_completed.connect(_on_level_completed)

func _on_level_completed():
	toggle(true)
