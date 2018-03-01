extends Node2D

var gametimer
var isPaused
var isStart

var isPressed

func _ready():
	gametimer = get_node("GameTimer")
	#gametimer.connect("timeout", self, "nightmare")
	
	isStart = false
	isPaused = false
	
	set_process(true)

func _process(delta):
	
	if (!isStart):
		gametimer.wait_time = 30
		gametimer.start()
		isStart = true

	if Input.is_key_pressed(KEY_P):
		isPressed = true
		
	if isPressed:
		if (!isPaused):
			#print ("meowe")
			gametimer.set_paused(true)
			isPaused = true
			get_tree().set_pause(true)
			isPressed = false
		else:
			gametimer.set_paused(false)
			isPaused = false
			get_tree().set_pause(false)
			isPressed = false
		
	get_node("/root/Base").timeLeft = gametimer.get_time_left()

func nightmare():
	#print ("hi")
	get_node("/root/Base/EnemyManager").enemySpawnTime = .25
	gametimer.stop()
	
func _gameOver():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
func changeTimer(value):
	var startTime = gametimer.get_time_left()
	gametimer.stop()
	#print (startTime - value)
	if ((startTime - (-value)) < 1):
		_gameOver()
	elif ((startTime - (-value)) >= 1):
		gametimer.wait_time = startTime + value
		
	gametimer.start()
	get_node("/root/Base").timeLeft = gametimer.get_time_left()
	#print (get_node("/root/Base").timeLeft)

func timeout():
	nightmare()
