extends "res://addons/godot-xr-tools/objects/viewport_2d_in_3d.gd"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	$"../ViewportGameOver".visible = false
	%GameManager.on_level_failed.connect(_on_level_failed)

func _on_level_failed():
	$"../ViewportGameOver".visible = true
