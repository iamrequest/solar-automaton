extends Area3D
class_name Hitbox

signal on_damage_dealth(int)

@export var damage: int
#@export var team_alignment: HealthComponent.HEALTH_TEAM

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	

func _on_area_entered(area: Area3D) -> void:
	var hurtbox = area as Hurtbox
	if(hurtbox):
		hurtbox.on_hitbox_collision(self)

func calculate_damage(hurtbox: Hurtbox) -> int:
	return damage
