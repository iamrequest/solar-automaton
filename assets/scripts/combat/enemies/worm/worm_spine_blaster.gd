extends Node3D
class_name WormSpineBlaster

signal on_death

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthComponent.on_death.connect(_on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_death() -> void:
	destroy()
	on_death.emit()

func destroy() -> void:
	$Hurtbox.monitoring = false
	$mesh.visible = false
	$EnemyBlaster.is_active = false
