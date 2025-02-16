extends Node3D

@export var initial_attack: WormAttack
@export var on_dead_attack: WormAttack

@export_category("Debug")
# Contains all attacks, except the initial and final "on death" attack
@export var attacks: Array[WormAttack]
@export var current_attack: WormAttack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attacks.clear()
	for child in get_children():
		if(child is WormAttack):
			if(child == initial_attack || child == on_dead_attack):
				continue
			attacks.append(child)
			child.on_attack_finished.connect(_on_attack_finished)
	
	initial_attack.on_attack_finished.connect(_on_attack_finished)
	on_dead_attack.on_attack_started.connect(_on_death_attack_started)
	start_attack(initial_attack)
	
	await get_tree().create_timer(10.0).timeout
	(%GameManager.bgm_manager as BGMManager).FadeIntensity(0.5, 10.0)
	

func start_attack(attack: WormAttack) -> void:
	current_attack = attack
	attack.start_attack()

func _on_attack_finished(last_attack: WormAttack):
	if(!%Worm.is_alive()):
		on_dead_attack.start_attack()
		
	else:
		if(last_attack.next_attack_options.size() == 0):
			print("Error! No followup attacks listed in attack %s " %last_attack.get_path())
			on_dead_attack.start_attack()
		else:
			start_attack(last_attack.next_attack_options.pick_random())

func _on_death_attack_started(attack: WormAttack) -> void:
	# TODO: Death SFX
	await get_tree().create_timer(15.0).timeout
	(%GameManager.bgm_manager as BGMManager).FadeIntensity(0.0, 10.0)
	await get_tree().create_timer(15.0).timeout
	%GameManager.set_level_completed()
	# Resume combat zone speed, to complete the level after a short delay
	#var combat_zone_manager = (Globals.game_manager.combat_zone_manager as CombatZoneManager)
	#if(combat_zone_manager):
		#combat_zone_manager.set_speed(0.5)
	#else:
#		print("Missing combat zone manager reference")
