extends Area3D
class_name GodHand

var is_active:= true
@export var hand: XRToolsHand

var pos_prev:= Vector3.ZERO
var velocity:= Vector3.ZERO

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _ready() -> void:
	pos_prev = global_position
	body_entered.connect(_on_body_entered)
	#%GameManager.on_level_completed.connect(_on_level_completed)
	#%GameManager.on_level_failed.connect(_on_level_completed)

func _physics_process(delta: float) -> void:
	calculate_velocity()

# Cheap velocity update- would be better to have velocity calculated over the past N frames
# Not necessary for this use-case
func calculate_velocity():
	velocity = global_position - pos_prev
	pos_prev = global_position

func _on_level_completed() -> void:
	toggle(false)
	
func _on_level_failed() -> void:
	toggle(false)

	
func toggle(is_active: bool) -> void:
	hand.visible = is_active
	$CollisionShape3D.disabled = !is_active
	$XRToolsFunctionPickup.enabled = is_active

func _on_body_entered(body: Node3D) -> void:
	if(body.has_method("_on_godhand_entered")):
		body._on_godhand_entered(self)
