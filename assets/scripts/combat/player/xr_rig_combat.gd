extends XRRig

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	%GameManager.on_level_completed.connect(_on_level_completed)
	%GameManager.on_level_failed.connect(_on_level_completed)
	%GameManager.on_paused.connect(_on_paused)
	%GameManager.on_unpaused.connect(_on_unpaused)

func _on_level_completed() -> void:
	toggle_laser(true)
	
func _on_level_failed() -> void:
	toggle_laser(true)
	
func _on_paused() -> void:
	toggle_laser(true)
	
func _on_unpaused() -> void:
	toggle_laser(false)
