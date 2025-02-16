extends Node
class_name HealthComponent

# TODO: Differentiating between fatal and non-fatal damage via signals would be nice
# Too much refactoring now tho
signal on_damage_recieved(int)
signal on_death
signal iframes_started
signal iframes_ended

var health_current: int
@export var health_max: int

var iframes_active:= false
var invincibility_enabled := false

#enum HEALTH_TEAM { Player, Enemy } 
#@export var team: HEALTH_TEAM

func _ready() -> void:
	health_current = health_max

func apply_damage(damage: int):
	if(iframes_active):
		return
	if(invincibility_enabled):
		return
	if(health_current <= 0):
		return
		
	try_set_iframes()
	
	health_current -= damage
	
	#print("Taking damage")
	on_damage_recieved.emit(damage)
	if(health_current <= 0):
		die()

func die():
	#print("Dying")
	on_death.emit()
	
# TODO: This would be better as composition
func try_set_iframes():
	if(get_node_or_null("IFrameTimer") == null):
		return

	iframes_active = true
	iframes_started.emit()
	$IFrameTimer.start()
	await $IFrameTimer.timeout
	iframes_active = false
	iframes_ended.emit()
	
	
func is_alive() -> bool:
	return health_current > 0

func can_damage() -> bool:
	if(!is_alive()): 
		return false
	
	if(iframes_active):
		return false
		
	return true
