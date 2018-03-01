extends Node2D

var timer
var isTimeDone

var heartScene

func _ready():
	timer = $Timer
	timer.connect("timeout", self, "timer_finished")
	
	isTimeDone = true
	
	heartScene  = load("res://Scenes/Heart.tscn")
	
	set_process(true)

func _process(delta):
	if (isTimeDone):
		timer.wait_time = 4
		timer.start()
		isTimeDone = false

func timer_finished():
	spawnHeart()
	
func spawnHeart():
	var rootNode = get_node("/root/Base")
	var heart = heartScene.instance()
	
	var randXPos = int(rand_range(-400, 400))
	var randYPos = int(rand_range(-400, 400))
	
	heart.position.x = randXPos
	heart.position.y = randYPos
	
	rootNode.add_child(heart)
	
	isTimeDone = true
