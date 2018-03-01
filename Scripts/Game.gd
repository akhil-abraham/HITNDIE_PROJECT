extends Node2D

var timeLeft setget setTimer

func _ready():
	pass

func setTimer(timer):
	timeLeft = timer
	var timeLeftStr = str(timeLeft)
	
	var digit1
	var digit2
	
	if timeLeft < 10:
		digit1 =  "0"
		digit2 = timeLeftStr[0]
	else:
		digit1 = timeLeftStr[0]
		digit2 = timeLeftStr[1]
	
	
	
	$CanvasLayer/Timer1.texture = load("res://Textures/Timer/Timer" + digit1 + ".png")
	$CanvasLayer/Timer2.texture = load("res://Textures/Timer/Timer" + digit2 + ".png")
	