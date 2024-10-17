extends VBoxContainer


var LastActivatedGoal = null
# Called when the node enters the scene tree for the first time.

var bIsPaused = false

@onready var GoalClass = load("res://Scenes/Goal.tscn")

func _ready():
	for goal in get_children():
		goal.queue_free()
	await get_tree().process_frame
	
	SaveManager.BeginSave.connect(OnSave)
	SaveManager.CompleteLoad.connect(OnCompleteLoad)

		
	
	var data = SaveManager.LoadData("Goals")
	if data:
		CreateGoalsFromData(data)
		
	else:
		AddGoal("Work", 1, 0, Helper.RING_TYPE.ALARM)
			

func GetData():
	var data = {}
	for x in range(0, get_child_count()):
		data[x] = get_child(x).GetData()
	return data
		
func OnSave():
	SaveManager.SaveData("Goals", GetData())
		
func OnCompleteLoad():
	for goal in get_children():
		goal.queue_free()
	var data = SaveManager.LoadData("Goals")
	if data:
		CreateGoalsFromData(data)

func CreateGoalsFromData(data):
	
	print("Attempting to create data from save" + str(data))
	for key in data.keys():
		var instance = AddGoal("",0,0, Helper.RING_TYPE.ALARM)
		instance.Load(data[key])

		
	
func OnGoalActivated(goal):
	LastActivatedGoal = goal
	goal.grab_focus()
	bIsPaused = false

	
func StopAllGoals():
	for goalchild in get_children():
		if goalchild is Goal:
			goalchild.Stop()
				
func _input(event):
	if Game.bIsInMenu:
		
		return		
	if event.is_action_pressed("pause"):
		if is_instance_valid(LastActivatedGoal):
			bIsPaused = !bIsPaused
			if bIsPaused:
				LastActivatedGoal.Stop(true)
			else:
				LastActivatedGoal.Start()
		
		
func UpdatePanels(index):
	for x in range(0, len(get_children())):
		get_child(x).ShowActivePanel(x == index)
	
func AddGoal(goalName, hours, minutes, ringType):
	var instance = GoalClass.instantiate()
	instance.GoalName = goalName
	instance.GoalInHours = hours
	instance.GoalInMinutes = minutes
	instance.GoalActivated.connect(Callable(self, "OnGoalActivated"))
	instance.RingType = ringType
	instance.ShowActivePanel(false)
	add_child(instance)
	return instance


func _on_child_exiting_tree(node):
	await get_tree().process_frame
	SaveManager.Save()
