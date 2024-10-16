extends Button



func _on_button_up():
	Game.GoalCreate.emit()
