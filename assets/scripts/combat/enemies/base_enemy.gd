extends RigidBody3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthComponent.on_death.connect(die)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func die() -> void:
	$DeathTimer.start()
	await $DeathTimer.timeout
	queue_free()
