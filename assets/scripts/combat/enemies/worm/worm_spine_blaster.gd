extends Node3D
class_name WormSpineBlaster

signal on_death

@onready var blaster: EnemyBlaster = $EnemyBlaster
@onready var laser: WormLaserBlaster = $Laser

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HealthComponent.on_death.connect(_on_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_damage_recieved(dmg: int) -> void:
	$DmgSFX.play_random_sfx()

func _on_death() -> void:
	$ExplosionSFX.play_random_sfx()
	destroy()
	on_death.emit()

func destroy() -> void:
	$Hurtbox.monitoring = false
	$mesh.visible = false
	set_blaster_type(BlasterType.None)


enum BlasterType { None, Projectile, Laser, Both}
func set_blaster_type(blaster_type: BlasterType):
	if($HealthComponent.health_current <= 0):
		blaster_type = BlasterType.None
		
	blaster.is_active = false
	laser.set_active(false)
	
	if(blaster_type == BlasterType.Projectile):
		blaster.is_active = true 
	elif(blaster_type == BlasterType.Laser):
		laser.set_active(true)
	elif(blaster_type == BlasterType.Both):
		blaster.is_active = true 
		laser.set_active(true)
