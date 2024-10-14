extends Control

var GoalName = "GoalName"

@onready var GoalTitle = $HBoxContainer/VBoxContainer/GoalTitle
@onready var HoursWorked = $HBoxContainer/VBoxContainer/HoursWorked

var Seconds = 0
var GoalInHours = 0
var GoalInMinutes = 0

func _ready():
	Update()
	
func Update():
	GoalTitle.text = GoalName
	HoursWorked.text = ConvertSecondsIntoText(Seconds) + "/" + GetGoalText()
	
func GetGoalText():
	return str(GoalInHours) + "h " + str(GoalInMinutes) + "m"
	
func ConvertSecondsIntoText(seconds):
	
	var result = str(seconds).format("%0.3f")

	return result
	
	


func _on_button_custom_press(bIsPlaying):
	if bIsPlaying:
		$Timer.start()
	else:
		$Timer.stop()
		


func _on_timer_timeout():
	Seconds += $Timer.wait_time
	Update()
