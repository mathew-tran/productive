extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	for goal in get_children():
		if goal is Goal:
			goal.GoalActivated.connect(Callable(self, "OnGoalActivated"))
			
			
func OnGoalActivated(goal):
	for goalchild in get_children():
		if goalchild is Goal:
			if goalchild != goal:
				goalchild.Stop()
				
