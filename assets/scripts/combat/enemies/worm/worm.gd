extends Node3D
class_name Worm

signal on_death
@export var head: Node3D
@export var spine_columns: Array[WormSpineColumn]
@export var tail: Node3D
@export var spine_column_length:= 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.setup(self)
	for spine in spine_columns:
		spine.health_component.on_death.connect(_on_component_death)
	configure_rotation()

func configure_rotation():
	var rot_deg = 0.0
	for spine in spine_columns:
		spine.rotator.set_rotation(rot_deg)
		rot_deg += 10.0
		
func _on_component_death() -> void:
	if(!is_alive()):
		on_worm_death()
		on_death.emit()

func is_alive() -> bool:
	for spine in spine_columns:
		if(spine.health_component.is_alive):
			return true
	return false


func on_worm_death():
	# Resume combat zone speed, to complete the level after a short delay
	var combat_zone_manager = (Globals.game_manager.combat_zone_manager as CombatZoneManager)
	if(combat_zone_manager):
		combat_zone_manager.set_speed(10.0)
	else:
		print("Missing combat zone manager reference")
