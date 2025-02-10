extends Hitbox
class_name Bullet

var speed := 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Add initial velocity?
	position = position - global_transform.basis.z * speed * delta


func _on_lifetime_timer_timeout() -> void:
	destroy_self()


func _on_body_entered(_body: Node3D) -> void:
	destroy_self()

func destroy_self():
	queue_free()
