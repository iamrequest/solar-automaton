extends Node3D
class_name WormAttack

signal on_attack_started(WormAttack)
signal on_attack_finished(WormAttack)

var current_path: WormMover
@export var next_attack_options: Array[WormAttack]
@export var blaster_type: WormSpineBlaster.BlasterType
@export var blaster_init_delay: float
@export_range(0.0, 1.0) var blaster_per_joint_delay: float
@export_range(0.0, 5.0) var rotation_speed_multiplier:=  1.0

@export_category("Debug")
@export var path_options: Array[WormMover]

func _ready() -> void:
	path_options.clear()
	for child in get_children():
		if(child is WormMover):
			path_options.append(child)

func start_attack() -> void:
	print("Worm attack started (%s)" % get_path())
	current_path = path_options.pick_random()
	print("  Worm Attack: Using path (%s)" % current_path.get_path())
	
	current_path.reset()
	current_path.is_active = true

	(%Worm as Worm).on_attack_started()
	set_worm_blaster_type()
	set_rotation_multiplier()
	
	current_path.path_completed.connect(_on_path_completed)
	on_attack_started.emit(self)

func _on_path_completed() -> void:
	print("Worm attack finished (%s)" % get_path())
	if(current_path.path_completed.is_connected(_on_path_completed)):
		current_path.path_completed.disconnect(_on_path_completed)

	on_attack_finished.emit(self)

	
func set_worm_blaster_type():
	(%Worm as Worm).disable_blasters()
	
	if(blaster_init_delay > 0):
		await get_tree().create_timer(blaster_init_delay).timeout
	(%Worm as Worm).set_blaster_type(blaster_type, blaster_per_joint_delay)

func set_rotation_multiplier():
	(%Worm as Worm).set_rotation_multiplier(rotation_speed_multiplier)
