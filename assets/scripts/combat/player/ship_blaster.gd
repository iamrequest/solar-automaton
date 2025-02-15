extends Node3D

@export var bullet_prefab: PackedScene
@export var bullet_spawn_points : Array[Node3D]
@export var fire_rate := 0.5
@export var bullet_speed := 0.5
@export_range(0.0, 1.0) var haptics_intensity = 0.1
@export_range(0.0, 1.0) var haptics_duration = 0.5

var is_on_cooldown = false
	
func _process(delta: float) -> void:
	if(Globals.xr_rig.get_dominant_hand().is_button_pressed("trigger_click")):
		if(!is_on_cooldown):
			fire_bullet()

func fire_bullet():
	for spawn_point in bullet_spawn_points:
		var bullet = bullet_prefab.instantiate() as Node3D
		if(!bullet):
			print("Unable to spawn bullet prefab!")
			return
		init_bullet(bullet, spawn_point)
	
	Globals.xr_rig.trigger_haptics(Globals.xr_rig.is_right_handed, haptics_intensity, haptics_duration)
	$AudioStreamPlayer3D.play_random_sfx()
	
	is_on_cooldown = true
	$FireCooldownTimer.start(fire_rate)
	
func init_bullet(bullet: Bullet, spawn_point: Node3D):
	get_tree().root.add_child(bullet)
	
	bullet.global_position = spawn_point.global_position
	bullet.global_rotation = spawn_point.global_rotation
	
	bullet.speed = bullet_speed
	

func _on_fire_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
