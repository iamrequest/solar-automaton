extends Node

signal on_player_ship_destroyed
signal on_level_completed

signal on_paused
signal on_unpaused


func _on_ship_on_death() -> void:
	on_player_ship_destroyed.emit()
