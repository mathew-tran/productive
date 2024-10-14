extends Control

class_name Goal

var GoalName = "GoalName"

@onready var GoalTitle = $HBoxContainer/VBoxContainer/GoalTitle
@onready var HoursWorked = $HBoxContainer/VBoxContainer/HoursWorked
@onready var CompletionProgress = $HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar

var Seconds = 0.0
var GoalInHours = 1
var GoalInMinutes = 0

var bHasBeenCompleted = false

signal GoalActivated(goal)

func _ready():
	Update()
	Engine.time_scale = 60
	Initialize()
	
func Initialize():
	CompletionProgress.min_value = 0
	
	var seconds = 0
	seconds += GoalInMinutes * 60
	seconds += GoalInHours * 60 * 60
	CompletionProgress.max_value = seconds
	
func Update():
	GoalTitle.text = GoalName
	HoursWorked.text = ConvertSecondsIntoText(Seconds) + " / " + GetGoalText()
	CompletionProgress.value = Seconds	
	
	if Seconds >= CompletionProgress.max_value:
		HoursWorked.modulate = Color.GREEN
	elif Seconds < CompletionProgress.max_value:
		HoursWorked.modulate = Color.WHITE
		
	var weight = CompletionProgress.value / CompletionProgress.max_value
	CompletionProgress.modulate = lerp(Color.YELLOW, Color.GREEN, weight)
	
func GetGoalText():
	return GetTimeText(GoalInHours, GoalInMinutes)
	
	
func GetTimeText(hours, minutes):
	var result = ""
	if hours > 0:
		result += str(round(hours)).pad_zeros(2) + "h "
	
	result += str(round(minutes)).pad_zeros(2) + "m"
	
	return result
	
func ConvertSecondsIntoText(seconds):	
	if seconds == 0:
		return GetTimeText(0, 0)
	var hours = int(seconds / 3600)
	var minutes = int((int(seconds) % 3600) / 60)
	
	var result = GetTimeText(hours, minutes)
	return result

func _on_button_custom_press(bIsPlaying):
	if bIsPlaying:
		$Timer.start()
		emit_signal("GoalActivated", self)
	else:
		Stop()
	
func Stop():
	$Timer.stop()
	$HBoxContainer/Button.ForceStop()

func _on_timer_timeout():
	Seconds += $Timer.wait_time * 100
	if bHasBeenCompleted == false and Seconds >= CompletionProgress.max_value:
		bHasBeenCompleted = true
		Helper.PlayComplete()
		
	Update()
