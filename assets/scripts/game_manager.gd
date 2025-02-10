extends Node

func _ready() -> void:
	$"../ViewportGameOver".visible = false
	
func _on_ship_on_death() -> void:
	$"../ViewportGameOver".visible = true
