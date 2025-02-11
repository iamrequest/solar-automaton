extends Node
class_name HealthComponent

signal on_damage_recieved(int)
signal on_death
signal iframes_started
signal iframes_ended

var health_current: int
@export var health_max: int

var iframes_active:= false

#enum HEALTH_TEAM { Player, Enemy } 
#@export var team: HEALTH_TEAM

func _ready() -> void:
	health_current = health_max

func apply_damage(damage: int):
	health_current -= damage
	
	#print("Taking damage")
	on_damage_recieved.emit(damage)
	if(health_current <= 0):
		die()

func die():
	#print("Dying")
	on_death.emit()
	
# TODO: This would be better as composition
func set_iframes():
	if($IFrameTimer != null):
		return
		
	# TODO: Support stacking iframes	
	#if(iframes_active):
	#	$IFrameTimer.stop()
	# Don't init iframe message
		
	iframes_active = true
	iframes_started.emit()
	await $IFrameTimer.start().timeout
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
