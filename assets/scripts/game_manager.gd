extends Node

signal on_level_completed
signal on_level_failed

signal on_paused
signal on_unpaused

var is_game_over:= false

func _on_ship_on_death() -> void:
	is_game_over = true
	$LevelFailedTimer.start()
	await $LevelFailedTimer.timeout
	on_level_failed.emit()


func _on_combat_zone_manager_on_level_end() -> void:
	is_game_over = true
	on_level_completed.emit()
