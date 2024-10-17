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

func GetGoals():
	var result = get_tree().get_nodes_in_group("GoalContainer")
	if result:
		return result[0]
	return null
