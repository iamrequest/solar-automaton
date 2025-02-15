extends Hitbox
class_name Bullet

var owner_health_component: HealthComponent
var initial_velocity := Vector3.ZERO
var speed := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += initial_velocity * delta
	position = position - global_transform.basis.z * speed * delta
	$MeshInstance3D.look_at(Globals.xr_rig.hmd.global_position, Vector3.UP, true)

func set_lifetime(lifetime: float) -> void:
	$LifetimeTimer.stop()
	$LifetimeTimer.start(lifetime)

func _on_lifetime_timer_timeout() -> void:
	destroy_self()


func _on_body_entered(_body: Node3D) -> void:
	destroy_self()

func destroy_self():
	queue_free()

# Don't damage self
func can_damage_target(hurtbox: Hurtbox):
	if(owner_health_component == hurtbox.health_component):
		return false
	return true
	# super()
