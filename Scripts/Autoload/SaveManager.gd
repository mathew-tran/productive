extends Node


var SavePath = "user://ProductiveData"

var Data = {}

func HasExistingData():
	return FileAccess.file_exists(SavePath)
	
func Save():
	var file = FileAccess.open(SavePath, FileAccess.READ_WRITE)
	var json_string = JSON.stringify(Data)
	file.store_line(Data)
	file.close()
		
func Load():
	var file = FileAccess.open(SavePath, FileAccess.READ)
	if file:
		var fileData = file.get_as_text()
		var json = JSON.parse_string(fileData)
		if json == OK:
			Data = json
	
func SaveData(category, data):
	Data[category] = data
	
func LoadData(category):
	if Data.has(category):
		return Data[category]
	return {}
