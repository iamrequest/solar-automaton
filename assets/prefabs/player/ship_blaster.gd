extends Node3D

@export var bullet_prefab: PackedScene
@export var bullet_spawn_point : Node3D
@export var fire_rate := 0.5
@export var bullet_speed := 0.5

var is_on_cooldown = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	# TODO: Get primary controller
	if(event.is_action("ui_accept")):
		if(!is_on_cooldown):
			fire_bullet()

func fire_bullet():
	var bullet = bullet_prefab.instantiate() as Node3D
	if(!bullet):
		print("Unable to spawn bullet prefab!")
		return
	
	is_on_cooldown = true
	$FireCooldownTimer.start(fire_rate)
	
	get_tree().root.add_child(bullet)
	init_bullet(bullet)
	
func init_bullet(bullet: Bullet):
	bullet.global_position = bullet_spawn_point.global_position
	bullet.rotation = bullet_spawn_point.rotation
	
	bullet.speed = bullet_speed
	

func _on_fire_cooldown_timer_timeout() -> void:
	is_on_cooldown = false
