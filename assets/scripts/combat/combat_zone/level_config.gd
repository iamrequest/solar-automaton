extends Resource
class_name LevelConfig

@export var num_zones:= 3
@export var spawnable_zones: Array[PackedScene]

func get_zone(i: int) -> PackedScene:
	if(spawnable_zones.size() == 0):
		print("No zones loaded in this config")
		return null
	if(spawnable_zones.size() < i):
		print("Attempted to get zone out of array bounds (%/%)" % [i, spawnable_zones.size()])
		return spawnable_zones[i % spawnable_zones.size()]
		
	return spawnable_zones[i]
