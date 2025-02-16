extends Resource
class_name SceneReferences

enum Scenes { Title, Sunset_1, Sunset_2, WormBoss }

func get_scene_path(scene_name: Scenes):
	match scene_name:
		Scenes.Title:
			return "res://assets/scenes/title.tscn"
		Scenes.Sunset_1:
			return "res://assets/scenes/lv01-1_sunset.tscn"
		Scenes.Sunset_2:
			return "res://assets/scenes/lv01-2_sunset.tscn"
		Scenes.WormBoss:
			return "res://assets/scenes/lv02_worm.tscn"
