extends Node2D

var grid = []
var probs = []

var blk_r = 5
var blk_l = 5
var blk_u = 5
var blk_d = 5

var point = []

var prob = {
	up = 0,
	down = 0,
	right = 0,
	left = 0
}

enum DIR {
	NULL, 
	BLOCK
}

func _ready():
	randomize()
	generate()

func generate():
	for x in range(0,8):
		grid.append([])
		for y in range (0,8):
			grid[x].append(NULL)
			
	point = [round(rand_range(0, 7)), 0]
	
	var num = round(rand_range(0,1))
	if num == 0:
		prob["up"] = 0
		prob["right"] = 50
		prob["down"] = 50
		prob["left"] = 0
	elif num == 1:
		prob["up"] = 50
		prob["right"] = 50
		prob["down"] = 0
		prob["left"] = 0
	
	grid[point[0]][point[1]] = BLOCK
	
	for z in range(0, 20):
		print (z)
		
				
	for x in range(0,8):
		print (grid[x])
				
		
func checkProb():
	if (point[0] == 0 || blk_u == 0):
		prob["up"] = 0
	if(point[0] == 7 || blk_d == 0):
		prob["down"] = 0
	if (point[1] == 0 || blk_l == 0):
		prob["left"]= 0
	if (point[1] == 7 || blk_r  == 0):
		prob["right"] = 0
		
	probs.clear()
	if !(prob["up"] == 0):
		probs.append("up")
	if !(prob["down"] == 0):
		probs.append("down")
	if !(prob["right"] == 0):
		probs.append("right")
	if !(prob["left"] == 0):
		probs.append("left")
	