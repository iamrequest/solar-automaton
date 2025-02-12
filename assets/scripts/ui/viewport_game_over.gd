extends ViewportBase


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	toggle(false)
	%GameManager.on_level_failed.connect(_on_level_failed)

func _on_level_failed():
	toggle(true)
	
