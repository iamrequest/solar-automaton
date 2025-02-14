extends XRToolsStaging

@export var main_scene_ref: SceneReferences.Scenes
@onready var scenes: SceneReferences = load("res://assets/scenes/scene_references.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_scene = scenes.get_scene_path(main_scene_ref)
	
	super()
