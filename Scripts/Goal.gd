extends Control

class_name Goal

@export var GoalName = "School"

@onready var GoalTitle = $HBoxContainer/VBoxContainer/GoalTitle
@onready var HoursWorked = $HBoxContainer/VBoxContainer/HoursWorked
@onready var CompletionProgress = $HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar

var Seconds = 0.0
@export var GoalInHours = 40
@export var GoalInMinutes = 0

var bHasBeenCompleted = false

signal GoalActivated(goal)

func _ready():
	Update()
	
	Initialize()

	
func Initialize():
	CompletionProgress.min_value = 0
	$Timer.start()
	$Timer.paused = true
	
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
	return GetTimeText(0, GoalInHours, GoalInMinutes)
	
	
func GetTimeText(seconds, hours, minutes):
	var result = ""
	
	if hours != 0 or minutes != 0:
		if hours > 0:
			result += str(round(hours)).pad_zeros(2) + "h "
		
		result += str(round(minutes)).pad_zeros(2) + "m"
	else:
		if seconds > 0:
			result += str(round(seconds)).pad_zeros(2) + "sec"
		else:
			result = "--"
	return result
	
func ConvertSecondsIntoText(seconds):	
	if seconds == 0:
		return GetTimeText(0, 0, 0)
	var hours = int(seconds / 3600)
	var minutes = int((int(seconds) % 3600) / 60)
	
	var result = GetTimeText(seconds, hours, minutes)
	return result

func _on_button_custom_press(bIsPlaying):
	if bIsPlaying:
		Start()
	else:
		Stop()

func Start():
	$Timer.paused = false	
	emit_signal("GoalActivated", self)
	$HBoxContainer/Button.ForcePlay()
	Helper.PlayStart()
	$AnimationPlayer.play("anim")
	
func Stop():
	if $Timer.paused:
		return
	$Timer.paused = true
	$HBoxContainer/Button.ForceStop()
	Helper.PlayStop()
	$AnimationPlayer.stop()

func _on_timer_timeout():
	Seconds += $Timer.wait_time
	if bHasBeenCompleted == false and Seconds >= CompletionProgress.max_value:
		bHasBeenCompleted = true
		Helper.PlayComplete()
		
	Update()

func ShowActivePanel(bShow):
	$Panel/ActivePanel.visible = bShow
