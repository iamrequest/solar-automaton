extends XRToolsPickable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	$HealthComponent.on_death.connect(_on_death)
	$DeathTimer.timeout.connect(die)
	$OnDroppedDeathTimer.timeout.connect(die)
	grabbed.connect(_on_grab)
	dropped.connect(_on_drop)
	body_entered.connect(_on_body_entered)

func _on_death() -> void:
	# TODO Explosion
	$DeathTimer.start()
	die()

func _on_grab(pickable: XRToolsPickable, by) -> void:
	$OnDroppedDeathTimer.stop()
	
func _on_drop(pickable: XRToolsPickable) -> void:
	# TODO: Kill gravity if dropped fast enough? Increase throw speed?
	# TODO Explosion
	linear_damp = 0.0
	$OnDroppedDeathTimer.start()

func die() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	print("body %s" % body.get_class())
