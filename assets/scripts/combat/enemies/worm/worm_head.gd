extends Node3D

@onready var worm: Worm = get_parent()
var health_component: HealthComponent:
	get:
		return $HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthComponent.on_damage_recieved.connect(_on_damaged)

func _on_damaged(damage: int): 
	for spine in worm.spine_columns:
		spine.health_component.apply_damage(damage)
