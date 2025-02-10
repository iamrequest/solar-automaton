extends Area3D
class_name Hurtbox

@export var health_component: HealthComponent

func on_hitbox_collision(hitbox: Hitbox) -> void:
	if(health_component != null && health_component.is_alive()):
		health_component.apply_damage(hitbox.calculate_damage(self))
