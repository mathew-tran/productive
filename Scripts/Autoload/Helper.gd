extends Node

enum RING_TYPE {
	SUBTLE,
	ALARM
}

func PlayComplete():
	GetAudioPlayer().stream = load("res://Audio/switch17.wav")
	GetAudioPlayer().play()

func PlayStart():
	GetAudioPlayer().stream = load("res://Audio/switch10.wav")
	GetAudioPlayer().play()

func PlayStop():
	GetAudioPlayer().stream = load("res://Audio/switch12.wav")
	GetAudioPlayer().play()
	
func GetAudioPlayer():
	var result = get_tree().get_nodes_in_group("SFX")
	if result:
		return result[0]
	return null

func ConvertSecondsIntoText(seconds):	
	if seconds == 0:
		return GetTimeText(0, 0, 0)
	var hours = int(seconds / 3600)
	var minutes = int((int(seconds) % 3600) / 60)
	
	var result = GetTimeText(seconds, hours, minutes, true)
	return result
	
func GetTotalSeconds(storedSeconds, startTime):
	var totalSeconds = storedSeconds
	if startTime != null:
		var currentTime = Time.get_unix_time_from_system()
		var currentSeconds = currentTime - startTime
		totalSeconds += currentSeconds
	return totalSeconds
	
func GetTimeText(seconds, hours, minutes, bShowAll = false):
	var result = ""
	
	if bShowAll:
		if hours > 0:
			result += str(round(hours)).pad_zeros(2) + "h "		
		result += str(round(minutes)).pad_zeros(2) + "m "
		result += str(int(seconds) % 60).pad_zeros(2) + "sec"
	else:
		if hours != 0 or minutes != 0:
			if hours > 0:
				result += str(round(hours)).pad_zeros(2) + "h "
			
			result += str(round(minutes)).pad_zeros(2) + "m"
		else:
			if seconds > 0:
				result += str((int(seconds % 60))).pad_zeros(2) + "sec"
			else:
				result = "--"
	return result
	
func GetGoals():
	var result = get_tree().get_nodes_in_group("GoalContainer")
	if result:
		return result[0]
	return null
