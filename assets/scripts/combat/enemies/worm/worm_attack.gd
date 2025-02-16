extends Node3D
class_name WormAttack

signal on_attack_started(WormAttack)
signal on_attack_finished(WormAttack)

var current_path: WormMover
@export var next_attack_options: Array[WormAttack]
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
	current_path.reset()
	print("  Worm Attack: Using path (%s)" % current_path.get_path())
	current_path.is_active = true
	current_path.path_completed.connect(_on_path_completed)
	
	on_attack_started.emit(self)

func _on_path_completed() -> void:
	print("Worm attack finished (%s)" % get_path())
	if(current_path.path_completed.is_connected(_on_path_completed)):
		current_path.path_completed.disconnect(_on_path_completed)

	on_attack_finished.emit(self)
