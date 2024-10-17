extends HBoxContainer

var bIsPreviewing = false

var CurrentRingType : Helper.RING_TYPE

func _ready():
	UpdateTexture()
	UpdateText()

func _on_button_button_up():
	bIsPreviewing = !bIsPreviewing
	if bIsPreviewing:
		$AudioStreamPlayer.play()
	else:
		$AudioStreamPlayer.stop()
	UpdateTexture()

func UpdateTexture():
	if bIsPreviewing:
		$Button.icon = load("res://Art/PreviewbuttonBlocked.png")
	else:
		$Button.icon = load("res://Art/Previewbutton.png")


func _on_ring_button_button_up():
	CurrentRingType += 1
	if CurrentRingType >= len(Helper.RING_TYPE.keys()):
		CurrentRingType = 0
	UpdateText()

func UpdateText():
	$RingButton.text = Helper.RING_TYPE.keys()[CurrentRingType]
	if CurrentRingType == Helper.RING_TYPE.SUBTLE:
		$Label.text = "Runs softly once"
	elif CurrentRingType == Helper.RING_TYPE.ALARM:
		$Label.text = "Runs like a normal alarm, won't be quiet until you pause"
	bIsPreviewing = false
	UpdateTexture()


func _on_audio_stream_player_finished():
	if CurrentRingType == Helper.RING_TYPE.SUBTLE:
		bIsPreviewing = false
		UpdateTexture()
	elif CurrentRingType == Helper.RING_TYPE.ALARM:
		$AudioStreamPlayer.play()

func OnClose():
	bIsPreviewing = false
	$AudioStreamPlayer.stop()
	UpdateText()
	UpdateTexture()

func Get():
	return CurrentRingType
	
func Reset():
	SetValue(0)


func SetValue(ringType):
	CurrentRingType = ringType
	UpdateText()
	
