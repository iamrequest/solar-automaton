extends Node3D

enum FireMode { FollowMarker, AimAtShip }

@export var sight_radius := 3
@export var bullet_prefab: PackedScene
@export var bullet_spawn_points : Array[Node3D]
@export var fire_rate := 0.5
@export var bullet_speed := 0.5
@export var fire_mode: FireMode
@export var apply_initial_bullet_velocity := true

var rb : RigidBody3D
var is_on_cooldown = false

func _ready() -> void:
	rb = get_parent()
	
func _process(delta: float) -> void:
	# TODO: Wait for player to be in radius
	if(!is_on_cooldown):
		fire_bullet()

func can_fire() -> bool:
	if(is_on_cooldown):
		return false
	
	if(Globals.xr_rig.get_dominant_hand()):
		var dist = Globals.xr_rig.get_dominant_hand().global_position.distance_to(global_position)
		if(dist > sight_radius):
			return false
			
	return true

func fire_bullet():
	for spawn_point in bullet_spawn_points:
		var bullet = bullet_prefab.instantiate() as Node3D
		if(!bullet):
			print("Unable to spawn bullet prefab!")
			return
		init_bullet(bullet, spawn_point)
	
	is_on_cooldown = true
	$FireCooldownTimer.start(fire_rate)
	
func init_bullet(bullet: Bullet, spawn_point: Node3D):
	get_tree().root.add_child(bullet)
	bullet.global_position = spawn_point.global_position
	
	match fire_mode:
		FireMode.FollowMarker:
			bullet.global_rotation = spawn_point.global_rotation
	
			if(apply_initial_bullet_velocity):
				bullet.initial_velocity = rb.linear_velocity
			bullet.speed = bullet_speed
			
		FireMode.AimAtShip:
			bullet.look_at(Globals.xr_rig.get_dominant_hand().global_position)
			
			if(apply_initial_bullet_velocity):
				bullet.initial_velocity = rb.linear_velocity
				
			bullet.speed = bullet_speed

func _on_fire_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
