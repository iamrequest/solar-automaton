extends Area3D
class_name PlayerTriggerArea

signal player_entered

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if(body is Ship):
		on_player_entered()
	pass

func on_player_entered():
	player_entered.emit()
