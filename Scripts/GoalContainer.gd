extends VBoxContainer


var LastActivatedGoal = null
# Called when the node enters the scene tree for the first time.

var bIsPaused = false

@onready var GoalClass = load("res://Scenes/Goal.tscn")

func _ready():
	for goal in get_children():
		if goal is Goal:
			goal.GoalActivated.connect(Callable(self, "OnGoalActivated"))
			goal.ShowActivePanel(false)
			
			
func OnGoalActivated(goal):
	LastActivatedGoal = goal
	bIsPaused = false
	for goalchild in get_children():
		if goalchild is Goal:
			if goalchild != goal:
				goalchild.Stop()
				goalchild.ShowActivePanel(false)
			else:
				goalchild.ShowActivePanel(true)
				
func StopAllGoals():
	for goalchild in get_children():
		if goalchild is Goal:
			goalchild.Stop()
				
func _input(event):
	if Game.bIsInMenu:
		return
		
	if event.is_action_pressed("pause"):
		bIsPaused = !bIsPaused
		if bIsPaused:
			StopAllGoals()
		else:
			if is_instance_valid(LastActivatedGoal):
				LastActivatedGoal.Start()
	if event.is_action_pressed("tab"):
		StopAllGoals()
		bIsPaused = true
		if LastActivatedGoal == null:
			LastActivatedGoal = get_child(0)
			UpdatePanels(0)
			
		else:
			var index = get_children().find(LastActivatedGoal)
			if index < get_child_count() - 1:
				index += 1
			else:
				index = 0 
			LastActivatedGoal = get_child(index)
			UpdatePanels(index)
		
		
func UpdatePanels(index):
	for x in range(0, len(get_children())):
		get_child(x).ShowActivePanel(x == index)
	
func AddGoal(goalName, hours, minutes):
	var instance = GoalClass.instantiate()
	instance.GoalName = goalName
	instance.GoalInHours = hours
	instance.GoalInMinutes = minutes
	add_child(instance)
