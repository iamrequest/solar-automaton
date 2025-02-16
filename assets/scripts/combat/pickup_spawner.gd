extends Node3D

@export var health_component: HealthComponent
@export var spawn_chance:= 0.3
@export var pickup_prefab: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health_component.on_death.connect(_on_death)
	

func _on_death() -> void:
	var r = randf()
	if(r <= spawn_chance):
		var scene_base : XRToolsSceneBase = XRTools.find_xr_ancestor(self, "*", "XRToolsSceneBase")
		if not scene_base:
			print("not scene base")
			return
		
		var instance = pickup_prefab.instantiate() as Node3D
		scene_base.add_child(instance)
		instance.global_position = global_position
