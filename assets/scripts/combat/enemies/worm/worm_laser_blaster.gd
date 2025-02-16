extends Hitbox
class_name WormLaserBlaster

func set_active(is_active: bool):
	$MeshInstance3D.visible = is_active
	$CollisionShape3D.disabled = !is_active
