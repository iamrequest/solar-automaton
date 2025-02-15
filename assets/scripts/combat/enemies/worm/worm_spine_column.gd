extends Node3D
class_name WormSpineColumn

signal on_death
var health_component: HealthComponent:
	get:
		return $HealthComponent

@export var blasters : Array[WormSpineBlaster]
var damage_on_blaster_death := 5
@export var mat_dead: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for blaster in blasters:
		blaster.on_death.connect(_on_blaster_death)
	$HealthComponent.on_death.connect(_on_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_blaster_death() -> void:
	$HealthComponent.apply_damage(damage_on_blaster_death)

func _on_death() -> void:
	$"worm_spine-joint/SpineJoint".set_surface_override_material(0, mat_dead)
	for blaster in blasters:
		blaster.destroy()
	on_death.emit()
