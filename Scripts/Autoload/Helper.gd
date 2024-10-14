extends Node

func PlayComplete():
	var result = get_tree().get_nodes_in_group("SFX")
	if result:
		result[0].play()
