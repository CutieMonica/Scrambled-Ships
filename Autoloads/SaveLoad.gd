extends Node

const save_location = "user://ScrambledShips.tres"

var SaveFileData: SaveDataResource = SaveDataResource.new()


func _ready() -> void:
	_load()
	
func _save() -> void:
	ResourceSaver.save(SaveFileData, save_location)
	print("Saving")

func _load() -> void:
	if FileAccess.file_exists(save_location):
		SaveFileData = ResourceLoader.load(save_location).duplicate(true)
		print("Loading")
