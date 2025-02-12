extends "res://addons/godot-xr-tools/objects/viewport_2d_in_3d.gd"
class_name ViewportBase

# TODO: Lerp screen to player in _process

func toggle(is_active: bool) -> void:
	visible = is_active
	enabled = is_active
