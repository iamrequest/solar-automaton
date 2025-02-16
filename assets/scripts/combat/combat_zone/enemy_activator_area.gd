extends PlayerTriggerArea

@export var path_mover:PathMover
@export var linear_mover:LinearMover

func _ready() -> void:
	super()
	if(path_mover):
		path_mover.update_in_process = false
	if(linear_mover):
		linear_mover.process_mode = Node.PROCESS_MODE_DISABLED
		
func on_player_entered():
	super()
	if(path_mover):
		path_mover.update_in_process = true
	if(linear_mover):
		linear_mover.process_mode = Node.PROCESS_MODE_INHERIT
