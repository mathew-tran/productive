extends LineEdit

func _ready():
	text_changed.connect(OnTextChanged)
	max_length = 2
	focus_entered.connect(OnFocusEntered)
	
func OnFocusEntered():
	caret_column = text.length()
	
func IsValid():
	return int(text) > 0

func OnTextChanged(newText: String):

	var validText = ""
	for char in newText:
		if char.is_valid_int():
			validText += char
	var number = int(validText)
	if number >= 60:
		number = 59
		validText = str(number)
		
	if validText != newText:
		text = validText

func Get():
	if IsValid():
		return int(text)
	return 0
	
func Reset():
	text = ""
	
