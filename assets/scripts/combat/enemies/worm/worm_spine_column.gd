extends Node3D
class_name WormSpineColumn

signal on_death
var health_component: HealthComponent:
	get:
		return $HealthComponent

@export var blasters : Array[WormSpineBlaster]
@export var rotator: WormJointRotator
var damage_on_blaster_death := 5
@export var mat_dead: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for blaster in blasters:
		blaster.on_death.connect(_on_blaster_death)
	$HealthComponent.on_damage_recieved.connect(on_damage_recieved)
	$HealthComponent.on_death.connect(_on_death)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_blaster_death() -> void:
	$HealthComponent.apply_damage(damage_on_blaster_death)

func on_damage_recieved(dmg: int) -> void:
	$DmgSFX.play_random_sfx()
	
func _on_death() -> void:
	$ExplosionSFX.play_random_sfx()
	$"Container/worm_spine-joint/SpineJoint".set_surface_override_material(0, mat_dead)
	for blaster in blasters:
		blaster.destroy()
	on_death.emit()

func set_blaster_type(blaster_type: WormSpineBlaster.BlasterType):
	for blaster in blasters:
		blaster.set_blaster_type(blaster_type)

func set_rotation_multiplier(mult: float):
	rotator.rotation_multiplier = mult
