extends Control

# Super inefficent way of rendering health, but I have an hour left lmao
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().process_frame
	Globals.ship.health_component.on_damage_recieved.connect(_on_ship_damaged)
	update_label()
	
func _on_ship_damaged(damage: int):
	update_label()
	
func update_label():
	if(Globals.invincibility_enabled):
		$VBoxContainer/HealthReadout.text = "-"
	else:
		$VBoxContainer/HealthReadout.text = str(Globals.ship.health_component.health_current)
