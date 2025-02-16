extends Node3D

@export var value:= 1
@export var rotate_speed := 1

var lerp_time_elapsed:= 0.0
@export var lerp_time := 0.5
@export var pos_curve: Curve
@export var scale_curve: Curve



@export var projectile_velocity:= Vector3.UP
@export var gravity_amount := 4.0
var projectile_pos = Vector3.ZERO

func _ready() -> void:
	projectile_pos = global_position
	$Timer.start(lerp_time)
	
func _process(delta: float) -> void:
	projectile_pos += projectile_velocity * delta
	projectile_pos += Vector3.DOWN * gravity_amount * gravity_amount * delta
	
	lerp_time_elapsed += delta
	var lerp_t = pos_curve.sample(lerp_time_elapsed / lerp_time)
	global_position = projectile_pos.lerp(Globals.xr_rig.get_dominant_hand().global_position, lerp_t)
	
	$MeshInstance3D.rotate_y(rotate_speed * delta)
	$MeshInstance3D.scale = Vector3.ONE * scale_curve.sample_baked(lerp_t)
	
func _on_timer_timeout() -> void:
	collect()
	
func collect():
	Globals.ship.add_health(1)
	$CollectSFX.play_random_sfx()
	queue_free()
