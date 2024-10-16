extends LineEdit

func _ready():
	max_length = 25
		
func IsValid():
	return text.length() > 0

func Get():
	if IsValid():
		return text
	return "INVALID"

func Reset():
	text = ""
