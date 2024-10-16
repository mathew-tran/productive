extends Node


signal GoalCreate

signal InMenu
signal OutOfMenu

var bIsInMenu = false

func _ready():
	InMenu.connect(OnInMenu)
	OutOfMenu.connect(OnOutOfMenu)
	
	
func OnInMenu():
	bIsInMenu = true
	
func OnOutOfMenu():
	bIsInMenu = false
