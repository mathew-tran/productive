extends Node


var SavePath = "user://ProductiveData"

var Data = {}

signal BeginSave
signal CompleteLoad

func _ready():
	if HasExistingData():
		Load()
		
func HasExistingData():
	return FileAccess.file_exists(SavePath)
	
func Save():
	BeginSave.emit()
	var file = FileAccess.open(SavePath, FileAccess.WRITE)
	var json_string = JSON.stringify(Data)
	file.store_line(json_string)
	file.close()
		
func Load():
	var file = FileAccess.open(SavePath, FileAccess.READ)
	if file:
		var fileData = file.get_as_text()
		var json = JSON.parse_string(fileData)
		if json != null:
			Data = json
	emit_signal("CompleteLoad")
	
func SaveData(category, data):
	Data[category] = data
	
func LoadData(category):
	if Data.has(category):
		return Data[category]
	return {}
