extends Panel

@onready var GoalTitle = $Content/Title/Label
@onready var GoalEdit = $Content/VBoxContainer/GridContainer/GoalEdit
@onready var HourEdit = $Content/VBoxContainer/GridContainer/TargetContainer/HourEdit
@onready var MinuteEdit = $Content/VBoxContainer/GridContainer/TargetContainer/MinuteEdit

@onready var DeleteButton = $Content/VBoxContainer/ActionContainer/Delete



enum MODE {
	CREATE,
	EDIT
}

var CurrentMode = MODE.CREATE
var Inputs = []

var GoalToEdit : Goal

func _ready():
	visible = false
	Inputs = [GoalEdit, HourEdit, MinuteEdit]
	Game.GoalCreate.connect(OnGoalCreate)
	Game.GoalEdit.connect(OnGoalEdit)
	
func _input(event):
	if visible:
		if event.is_action_pressed("escape"):
			visible = false
			
func OnGoalCreate():
	ShowCreate()
	
func OnGoalEdit(goal):
	ShowEdit(goal)

func ShowEdit(goal : Goal):
	GoalEdit.text = goal.GoalName
	HourEdit.text = str(goal.GoalInHours)
	MinuteEdit.text = str(goal.GoalInMinutes)
	GoalTitle.text = "Edit: " + goal.GoalName
	CurrentMode = MODE.EDIT
	DeleteButton.visible = false
	GoalToEdit = goal
	visible = true
	
func ShowCreate():
	for input in Inputs:
		input.Reset()
	GoalTitle.text = "Create a goal"
	CurrentMode = MODE.CREATE
	DeleteButton.visible = false
	visible = true


func AddGoal():
	Helper.GetGoals().AddGoal(GoalEdit.Get(), HourEdit.Get(), MinuteEdit.Get())
	
func UpdateGoal():
	GoalToEdit.GoalName = GoalEdit.Get()
	GoalToEdit.GoalInHours = HourEdit.Get()
	GoalToEdit.GoalInMinutes = MinuteEdit.Get()
	GoalToEdit.Update()
	GoalToEdit.Initialize()
	GoalToEdit.Stop(true)
	SaveManager.Save()

func _on_discard_button_up():
	visible = false

func IsDataValid():
	var timeInputs = HourEdit.IsValid() or MinuteEdit.IsValid()
	return timeInputs == true and GoalEdit.IsValid()
	
func _on_confirm_button_up():
	if IsDataValid():
		if CurrentMode == MODE.CREATE:
			AddGoal()
		elif CurrentMode == MODE.EDIT:
			UpdateGoal()
		SaveManager.Save()
		visible = false
		
	else:
		print("unable to complete edit goal")


func _on_discard_visibility_changed():
	if is_visible_in_tree():
		GoalEdit.grab_focus()
		Game.InMenu.emit()
	else:
		Game.OutOfMenu.emit()
	
