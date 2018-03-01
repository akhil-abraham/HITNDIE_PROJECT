extends KinematicBody2D

var state
var stateChange
var id

var isChase

var dir = Vector2(0, 1)
var dist
var absdistX
var absdistY

var playerNode

var health
var healthBar

var fakeDelta

export var SPEED = 25

enum STATES {
	ATTACK,
	CHASE	
}

func _ready():
	health = 100
	healthBar = get_node("Health/TextureProgress")
	
	playerNode = get_node("/root/Base/Player")
	
	get_tree().connect("idle_frame", self, "stateFunc")
	set_physics_process(true)
	
func _physics_process(delta):
	fakeDelta = delta
	#print (delta)
	healthBar.value = health
	
	if (health <= 0):
		get_node("/root/Base/TimerNode").changeTimer(5)
		queue_free()

	absdistX = abs(playerNode.get_node("Origin").global_position.x - $Origin.global_position.x)
	absdistY = abs(playerNode.get_node("Origin").global_position.y - $Origin.global_position.y)
	
	#print (str(absdistX) + "X")
	#print (str(absdistY) + "Y")
	
	if (absdistX <= 30 || absdistY <= 20) && !(absdistX >= 50 || absdistY >= 55):
		
		if !(state == STATES.ATTACK):
			state = STATES.ATTACK
			
	else:
		state = STATES.CHASE
			
	if isChase:
		move_and_collide(dir * delta *SPEED)
	
	match dir:
		Vector2(0, -1): #Up
			$Sword.dir = "Up"
		Vector2(0, 1): #Down
			$Sword.dir = "Down"
		Vector2(-1, 0): #Left
			$Sword.dir  = "Left"
		Vector2(1, 0): #Right
			$Sword.dir = "Right"
		
func stateFunc():
	match state:
		STATES.ATTACK:
			isChase = false

			if absdistY < 0:#if player is above
				$Hitscan.scan("Up")
				if !($Hitscan.isScan):
					if absdistX < 0:
						$Hitscan.scan("Left")
						if $Hitscan.isScan:
							dir = Vector2(-1, 0)
							$Sword.isAttack = true
					elif absdistX > 0:
						$Hitscan.scan("Right")
						if $Hitscan.isScan:
							dir = Vector2(1, 0)
							$Sword.isAttack = true
				else:
					$Sword.isAttack = true
					$Hitscan.isScan = false
			elif absdistY > 0:
				$Hitscan.scan("Down")
				if !($Hitscan.isScan):
					if absdistX < 0:
						$Hitscan.scan("Left")
						if $Hitscan.isScan:
							dir = Vector2(-1, 0)
							$Sword.isAttack = true
					elif absdistX > 0:
						$Hitscan.scan("Right")
						if $Hitscan.isScan:
							dir = Vector2(1, 0)
							$Sword.isAttack = true
				else:
					$Sword.isAttack = true
					$Hitscan.isScan = false
			
		STATES.CHASE:
			$Sword.isAttack = false
			
			var distX = playerNode.position.x - position.x
			var distY = playerNode.position.y - position.y
			
			if absdistX >= (SPEED * fakeDelta) || absdistY >= (SPEED * fakeDelta):
				if absdistX >= (SPEED * fakeDelta) && absdistY >= (SPEED * fakeDelta):
					if absdistX > absdistY:
						if distX < 0:
							dir = Vector2(-1, 0)
						else:
							dir = Vector2(1, 0)
					elif absdistY > absdistX:
						if distY < 0:
							dir = Vector2(0, -1)
						else:
							dir = Vector2(0, 1)			
				elif absdistX >= (SPEED * fakeDelta) && !(absdistY >= (SPEED * fakeDelta)):
					if distX < 0:
						dir = Vector2(-1, 0)
					else:
						dir = Vector2(1, 0)
				elif !(absdistX >= (SPEED * fakeDelta)) && absdistY >= (SPEED * fakeDelta):
					if distY < 0:
						dir = Vector2(0, -1)
					else:
						dir = Vector2(0, 1)
						
			isChase = true
				
				
func _on_hit():
	health -= 34
	get_node("/root/Base/Player").health -= 20
