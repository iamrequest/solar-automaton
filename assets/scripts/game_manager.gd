extends Node

signal on_level_completed
signal on_level_failed

signal on_paused
signal on_unpaused


func _on_ship_on_death() -> void:
	$LevelFailedTimer.start()
	await $LevelFailedTimer.timeout
	on_level_failed.emit()
