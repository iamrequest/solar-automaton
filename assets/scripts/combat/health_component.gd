extends Node
class_name HealthComponent

signal on_damage_recieved(int)
signal on_death

var health_current: int
@export var health_max: int

func _ready() -> void:
	health_current = health_max

func apply_damage(damage: int):
	health_current -= damage
	
	on_damage_recieved.emit(damage)
	if(health_current <= 0):
		on_death.emit()

func is_alive() -> bool:
	return health_current > 0
