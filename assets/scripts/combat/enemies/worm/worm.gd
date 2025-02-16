extends Node3D
class_name Worm

signal on_death
var num_dead_joints:= 0

@export var head: Node3D
@export var spine_columns: Array[WormSpineColumn]
@export var tail: Node3D
@export var spine_column_length:= 6.0
@export_range(0.0, 1.0) var bgm_intensity: Array[float]
@export_range(0.0, 3.0) var bgm_fade_duration: float
@export var enable_lasers_after_joint_death_count := 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.setup(self)
	for spine in spine_columns:
		spine.on_death.connect(_on_component_death)
	configure_rotation()
	disable_blasters()

func configure_rotation():
	var rot_deg = 0.0
	for spine in spine_columns:
		spine.rotator.set_rotation(rot_deg)
		rot_deg += 10.0
		
func _on_component_death() -> void:
	num_dead_joints += 1
	
	if(!is_alive()):
		on_worm_death()
		on_death.emit()
	else:
		var bgm_intensity = bgm_intensity[min(bgm_intensity.size() - 1, num_dead_joints)]
		print("Setting BGM intensity to %s" % str(bgm_intensity))
		(%GameManager.bgm_manager as BGMManager).FadeIntensity(bgm_intensity, bgm_fade_duration)

func is_alive() -> bool:
	for spine in spine_columns:
		if(spine.health_component.health_current > 0):
			return true
	return false


func on_worm_death():
	pass

func disable_blasters() -> void:
	for spine in spine_columns:
		spine.set_blaster_type(WormSpineBlaster.BlasterType.None)
	
func set_blaster_type(blaster_type: WormSpineBlaster.BlasterType, per_joint_delay: float):
	if(num_dead_joints >= enable_lasers_after_joint_death_count):
		if(blaster_type == WormSpineBlaster.BlasterType.Projectile):
			blaster_type = WormSpineBlaster.BlasterType.Both
			
	for spine in spine_columns:
		spine.set_blaster_type(blaster_type)
		if(per_joint_delay > 0):
			await get_tree().create_timer(per_joint_delay).timeout


func set_rotation_multiplier(mult: float):
	for spine in spine_columns:
		spine.set_rotation_multiplier(mult)
