extends PlayerTriggerArea

@export var speed := 1.0

func on_player_entered():
	super()
	var combat_zone_manager = (Globals.game_manager.combat_zone_manager as CombatZoneManager)
	if(combat_zone_manager):
		combat_zone_manager.set_speed(speed)
	else:
		print("Missing combat zone manager reference")
