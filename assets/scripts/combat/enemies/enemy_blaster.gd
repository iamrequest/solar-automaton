extends Node3D
class_name EnemyBlaster

enum FireMode { FollowMarker, AimAtShip }
var is_active := true

@export var health_component: HealthComponent
@export var sight_radius := 5
@export var min_dot_product:= -1.0
@export var bullet_prefab: PackedScene
@export var bullet_spawn_points : Array[Node3D]
@export var fire_rate := 0.5
@export var bullet_speed := 0.5
@export var bullet_lifetime := 5
@export var fire_mode: FireMode
@export var fire_mode_grabbed: FireMode
@export var apply_initial_bullet_velocity := true
@export var aim_pos_offset: float

var rb : RigidBody3D
var is_on_cooldown = false

func _ready() -> void:
	if(get_parent() is RigidBody3D):
		rb = get_parent()
	
func _process(delta: float) -> void:
	if(!is_active):
		return
		
	if(can_fire()):
		fire_bullet()

func can_fire() -> bool:
	if(is_on_cooldown):
		return false
	
	if(is_behind_player()):
		return false
	
	if(!is_angle_to_player_valid()):
		return false
		
	if(is_below_xr_marker()):
		return false
	
	if(Globals.xr_rig.get_dominant_hand()):
		var dist = Globals.xr_rig.get_dominant_hand().global_position.distance_to(global_position)
		if(dist > sight_radius):
			return false
			
	return true

func is_behind_player() -> bool:
	var czm = Globals.game_manager.combat_zone_manager
	var dir_to_spawn = (czm.spawn_marker.global_position - global_position).normalized()
	var dir_to_rig = (czm.xr_rig_marker.global_position - global_position).normalized()
	
	return dir_to_spawn.dot(dir_to_rig) > 0.5

func is_angle_to_player_valid():
	var dir_marker_to_player = (Globals.xr_rig.get_dominant_hand().global_position - bullet_spawn_points[0].global_position).normalized()
	
	return -bullet_spawn_points[0].global_transform.basis.z.dot(dir_marker_to_player) >= min_dot_product

func is_below_xr_marker() -> bool:
	return global_position.y < Globals.game_manager.combat_zone_manager.xr_rig_marker.global_position.y
		
func fire_bullet():
	for spawn_point in bullet_spawn_points:
		var bullet = bullet_prefab.instantiate() as Node3D
		if(!bullet):
			print("Unable to spawn bullet prefab!")
			return
		init_bullet(bullet, spawn_point)
	
	is_on_cooldown = true
	$BlasterSFX.play_random_sfx()
	$FireCooldownTimer.start(fire_rate)

func get_linear_velocity() -> Vector3:
	if(rb):
		return rb.linear_velocity
	else:
		return global_position - position
			
func init_bullet(bullet: Bullet, spawn_point: Node3D):
	# Instantiate as a child of the scene base
	var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
	if not scene_base:
		return
		
	scene_base.add_child(bullet)
	
	bullet.global_position = spawn_point.global_position
	bullet.set_lifetime(bullet_lifetime)
	bullet.owner_health_component = health_component
	
	match fire_mode:
		FireMode.FollowMarker:
			bullet.global_rotation = spawn_point.global_rotation
	
			if(apply_initial_bullet_velocity):
				bullet.initial_velocity = get_linear_velocity()
			bullet.speed = bullet_speed
			
		FireMode.AimAtShip:
			bullet.look_at(Globals.xr_rig.get_dominant_hand().global_position + get_offset_pos())
			
			if(apply_initial_bullet_velocity):
				bullet.initial_velocity = get_linear_velocity()
				
			bullet.speed = bullet_speed

func get_offset_pos():
	var pos = Vector3.ZERO
	pos.x += randf_range(-aim_pos_offset, aim_pos_offset)
	pos.y += randf_range(-aim_pos_offset, aim_pos_offset)
	pos.y += randf_range(-aim_pos_offset, aim_pos_offset)
	return pos
	
func _on_fire_cooldown_timer_timeout() -> void:
	is_on_cooldown = false

func _on_enemy_on_godhand_kill() -> void:
	fire_mode = fire_mode_grabbed

func _on_enemy_grabbed(pickable: Variant, by: Variant) -> void:
	fire_mode = fire_mode_grabbed


func _on_enemy_on_marked_for_death() -> void:
	pass # Replace with function body.



#region velocity calculation
var pos_prev:= Vector3.ZERO
func _physics_process(delta: float) -> void:
	# Cheap velocity update- would be better to have velocity calculated over the past N frames
	# Not necessary for this use-case
	pos_prev = global_position
#endregion
