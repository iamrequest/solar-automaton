extends Node3D

var worm: Worm
var health_component: HealthComponent:
	get:
		return $HealthComponent

# Called when the node enters the scene tree for the first time.
func setup(worm_ref) -> void:
	worm = worm_ref
	$HealthComponent.on_damage_recieved.connect(_on_damaged)
	
func _on_damaged(damage: int): 
	for spine in worm.spine_columns:
		spine.health_component.apply_damage(damage)
	$DmgSFX.play_random_sfx()
