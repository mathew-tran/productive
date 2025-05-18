extends Button
	
func _on_button_up() -> void:
	var data = SaveManager.LoadData("Goals")
	var dataToShow = ""
	for goal in data:
		var goalData = data[goal]
		dataToShow += goalData["GoalName"]
		
		var timeUsed = Helper.GetTotalSeconds(goalData["StoredSeconds"], goalData["TimeActivated"])
		timeUsed = Helper.ConvertSecondsIntoText(timeUsed)
		dataToShow += ": " + str(timeUsed)
		dataToShow += "\n"
	DisplayServer.clipboard_set(dataToShow)
