extends Button


var bIsPlaying = false

signal CustomPress(bIsPlaying)

func _ready():
	UpdateTexture()
	
func _on_button_up():
	bIsPlaying = !bIsPlaying
	release_focus()
	emit_signal("CustomPress", bIsPlaying)
	
func UpdateTexture():
	if bIsPlaying:
		theme = load("res://Themes/PausedTheme.tres")
	else:
		theme = load("res://Themes/PlayedTheme.tres")

func ForceStop():
	bIsPlaying = false
	UpdateTexture()

func ForcePlay():
	bIsPlaying = true
	UpdateTexture()
