extends Control

class_name Goal

@export var GoalName = "School"

@onready var GoalTitle = $HBoxContainer/VBoxContainer/GoalTitle
@onready var HoursWorked = $HBoxContainer/VBoxContainer/HoursWorked
@onready var CompletionProgress = $HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar
@onready var ProgressPercentText = $HBoxContainer/VBoxContainer/HBoxContainer/ProgressBar/ProgressPercent

var StoredSeconds = 0.0
@export var GoalInHours = 40
@export var GoalInMinutes = 0

var StartTime
var bHasBeenCompleted = false

var RingType : Helper.RING_TYPE

signal GoalActivated(goal)

func GetData():
	return {
		"GoalName" : GoalName,
		"TimeActivated" : StartTime,
		"StoredSeconds" : StoredSeconds,
		"GoalInHours" : GoalInHours,
		"GoalInMinutes" : GoalInMinutes,
		"RingType" : RingType
	}
	
func Load(data):
	GoalName = data["GoalName"]
	StartTime = data["TimeActivated"]
	StoredSeconds = data["StoredSeconds"]
	GoalInHours = data["GoalInHours"]
	GoalInMinutes = data["GoalInMinutes"]
	RingType = data["RingType"]
	
	Initialize()
	
	if StartTime != null:
		Stop(true)
	Update()
	
func _ready():
	Update()	
	Initialize()
	
func Initialize():
	CompletionProgress.min_value = 0
	bHasBeenCompleted = false
	$Timer.start()
	$Timer.paused = true
	
	var seconds = 0
	seconds += GoalInMinutes * 60
	seconds += GoalInHours * 60 * 60
	CompletionProgress.max_value = seconds
	Update()
	
func GetTotalSeconds():
	var totalSeconds = StoredSeconds
	
	if StartTime != null:
		var currentTime = Time.get_unix_time_from_system()
		var currentSeconds = currentTime - StartTime
		totalSeconds += currentSeconds
	return totalSeconds
	
func Update():
	GoalTitle.text = GoalName
	
	var totalSeconds = GetTotalSeconds()
	HoursWorked.text = ConvertSecondsIntoText(totalSeconds) + " / " + GetGoalText()
	CompletionProgress.value = totalSeconds	
	ProgressPercentText.text = str(snapped(((totalSeconds / CompletionProgress.max_value)* 100), .01)).pad_decimals(1) + "%"
	
	if totalSeconds >= CompletionProgress.max_value:
		HoursWorked.modulate = Color.GREEN
	elif totalSeconds < CompletionProgress.max_value:
		HoursWorked.modulate = Color.WHITE
		
	var weight = CompletionProgress.value / CompletionProgress.max_value
	CompletionProgress.modulate = lerp(Color.YELLOW, Color.GREEN, weight)
	if RingType == Helper.RING_TYPE.SUBTLE:
		$AlarmType.text = "SUBTLE"
	if RingType == Helper.RING_TYPE.ALARM:
		$AlarmType.text = "ALARM
		"
func GetGoalText():
	return GetTimeText(0, GoalInHours, GoalInMinutes)
	
	
func GetTimeText(seconds, hours, minutes, bShowAll = false):
	var result = ""
	
	if bShowAll:
		if hours > 0:
			result += str(round(hours)).pad_zeros(2) + "h "		
		result += str(round(minutes)).pad_zeros(2) + "m "
		result += str(int(seconds) % 60).pad_zeros(2) + "sec"
	else:
		if hours != 0 or minutes != 0:
			if hours > 0:
				result += str(round(hours)).pad_zeros(2) + "h "
			
			result += str(round(minutes)).pad_zeros(2) + "m"
		else:
			if seconds > 0:
				result += str((int(seconds % 60))).pad_zeros(2) + "sec"
			else:
				result = "--"
	return result
	
func ConvertSecondsIntoText(seconds):	
	if seconds == 0:
		return GetTimeText(0, 0, 0)
	var hours = int(seconds / 3600)
	var minutes = int((int(seconds) % 3600) / 60)
	
	var result = GetTimeText(seconds, hours, minutes, true)
	return result

func _on_button_custom_press(bIsPlaying):
	if bIsPlaying:
		Start()
	else:
		Stop()

func Start():
	StartTime = Time.get_unix_time_from_system()
	$Timer.paused = false	
	emit_signal("GoalActivated", self)
	$HBoxContainer/Button.ForcePlay()
	Helper.PlayStart()
	$AnimationPlayer.play("anim")
	ShowActivePanel(true)
	SaveManager.Save()
	
func Stop(bForce = false):
	if $Timer.paused and bForce == false:
		return
	$Timer.paused = true
	$HBoxContainer/Button.ForceStop()
	Helper.PlayStop()
	$AnimationPlayer.stop()
	ShowActivePanel(false)
	UpdateStoredTime()
	$AudioStreamPlayer.stop()
	
	

func UpdateStoredTime():
	if StartTime != null:
		StoredSeconds += Time.get_unix_time_from_system() - StartTime
		StartTime = null
		SaveManager.Save()
	
func _on_timer_timeout():
	if bHasBeenCompleted == false and GetTotalSeconds() >= CompletionProgress.max_value:
		bHasBeenCompleted = true
		$AudioStreamPlayer.play()
		
	Update()

func ShowActivePanel(bShow):
	$Panel/ActivePanel.visible = bShow
	$OptionButtons.visible = !bShow


func _on_delete_button_up():
	queue_free()
	


func _on_reset_button_button_up():
	
	Stop(true)
	StoredSeconds = 0
	Update()


func _on_edit_button_up():
	Game.GoalEdit.emit(self)



func _on_audio_stream_player_finished():
	if RingType == Helper.RING_TYPE.SUBTLE:
		pass
	if RingType == Helper.RING_TYPE.ALARM:
		$AudioStreamPlayer.play()
