extends Node

var is_on_cooldown = false
@export var sight_radius := 3
@export var fire_rate := 0.5


func _process(delta: float) -> void:
	# TODO: Optionally look at player w/ lerp
	if(Globals.xr_rig.get_dominant_hand()):
		$Marker3D.look_at(Globals.xr_rig.get_dominant_hand().global_position)
		
	# TODO: Wait for player to be in radius
	if(!is_on_cooldown):
		fire_bullet()

func can_fire() -> bool:
	if(is_on_cooldown):
		return false
	return true

# TODO: Need lead up indicator to firing
func fire_bullet():
	# TODO: Enable area collider
	
	is_on_cooldown = true
	$FireCooldownTimer.start(fire_rate)
