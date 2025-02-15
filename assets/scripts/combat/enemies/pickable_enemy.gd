extends XRToolsPickable
class_name PickableEnemy

# Emitted when health is depleted, or is grabbed
signal on_marked_for_death
var is_godhand_smackable := true

@export var godhand_collision_kill_velocity := 0.015
@export var godhand_kill_force_ceiling := 4

@export var kill_duration_health_depleted := 0.1
@export var kill_duration_godhand_smack := 0.5
@export var kill_duration_godhand_drop := 0.75

@export_range(0.0, 1.0) var haptics_intensity_on_death = 0.5
@export_range(0.0, 1.0) var haptics_duration_on_death = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$HealthComponent.on_death.connect(_on_death)
	$DeathTimer.timeout.connect(_on_death_timer_timeout)
	grabbed.connect(_on_grab)
	dropped.connect(_on_drop)

func _on_death() -> void:
	# Disable grabbing
	enabled = false
	is_godhand_smackable = false
	
	# TODO Explosion
	$DeathTimer.start(kill_duration_health_depleted)

func _on_grab(pickable: XRToolsPickable, by) -> void:
	$DeathTimer.stop()
	on_marked_for_death.emit()
	
func _on_drop(pickable: XRToolsPickable) -> void:
	# TODO: Kill gravity if dropped fast enough? Increase throw speed?
	# TODO Explosion
	linear_damp = 0.0
	gravity_scale = 0.25
	$DeathTimer.start(kill_duration_godhand_drop)

	await get_tree().process_frame 

func _on_death_timer_timeout() -> void:
	drop()
	Globals.xr_rig.trigger_haptics(true, haptics_intensity_on_death, haptics_duration_on_death)
	Globals.xr_rig.trigger_haptics(false, haptics_intensity_on_death, haptics_duration_on_death)
	queue_free()

func _on_godhand_entered(godhand: GodHand) -> void:
	if(is_picked_up()):
		return
	if(!is_godhand_smackable):
		return
	
	# TODO: Calculate relative velocity instead
	var relative_velocity = godhand.velocity - linear_velocity
	if(relative_velocity.length() >= godhand_collision_kill_velocity):
		linear_damp = 0.0
		gravity_scale = 0.25
		var force_magnitude = godhand_kill_force_ceiling
		apply_central_impulse(relative_velocity.normalized() * force_magnitude)
		
		is_godhand_smackable = true
		on_marked_for_death.emit()
		$DeathTimer.start(kill_duration_godhand_smack)
