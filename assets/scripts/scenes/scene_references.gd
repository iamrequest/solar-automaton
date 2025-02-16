extends Resource
class_name SceneReferences

enum Scenes { Title, Sunset, WormBoss }

func get_scene_path(scene_name: Scenes):
	match scene_name:
		Scenes.Title:
			return "res://assets/scenes/title.tscn"
		Scenes.Sunset:
			return "res://assets/scenes/lv01_sunset.tscn"
		Scenes.WormBoss:
			return "res://assets/scenes/lv02_worm.tscn"
