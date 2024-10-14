extends Button


var bIsPlaying = false

func _ready():
	UpdateTexture()
	
func _on_button_up():
	bIsPlaying = !bIsPlaying
	UpdateTexture()
	release_focus()
	
	
func UpdateTexture():
	if bIsPlaying:
		theme = load("res://Themes/PausedTheme.tres")
	else:
		theme = load("res://Themes/PlayedTheme.tres")
