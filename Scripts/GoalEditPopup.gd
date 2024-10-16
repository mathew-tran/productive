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
func _ready():
	visible = false
	Inputs = [GoalEdit, HourEdit, MinuteEdit]
	Game.GoalCreate.connect(OnGoalCreate)
	
func OnGoalCreate():
	ShowCreate()
	
	
func ShowCreate():
	visible = true
	for input in Inputs:
		input.Reset()
	GoalTitle.text = "Create a goal"
	CurrentMode = MODE.CREATE
	DeleteButton.visible = false
	pass

func ShowGoal(goal : Goal):
	visible = true
	GoalTitle.text = "Edit Goal: " + goal.GoalName


func AddGoal():
	Helper.GetGoals().AddGoal(GoalEdit.Get(), HourEdit.Get(), MinuteEdit.Get())
	
func UpdateGoal():
	pass

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
		visible = false
		
	else:
		print("unable to complete edit goal")


func _on_discard_visibility_changed():
	if is_visible_in_tree():
		GoalEdit.grab_focus()
		Game.InMenu.emit()
	else:
		Game.OutOfMenu.emit()
