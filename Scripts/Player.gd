extends KinematicBody2D

export var SPEED = 225

var velocity = Vector2()
var anim

var maxHealth = 150000000
var health
var healthBar

var dir
var isIdleAnimPlaying

var isClone
var isTweened

var isColOff = false

enum DIR {
	UP,
	DOWN,
	LEFT,
	RIGHT	
}

func _ready():
	#$Sword.dir = DOWN
	dir = DOWN
	isIdleAnimPlaying = false
	
	anim = get_node("AnimatedSprite")
	anim.play("idleDown")
	
	health = maxHealth
	healthBar = get_node("Health/TextureProgress")
	
	
	set_physics_process(true)
	
func _physics_process(delta):
	#if !(isColOff): THIS WAS A WEIRD FIX TO THAT BUG I WAS TALKING ABOUT. I DONT KNOW WHY THIS WORKS HOWEVER
	#	$CollisionShape2D.disabled = false
	#	isColOff = true
	
	if (isClone):
		$CollisionShape2D.disabled = true
		#$Sword/CollisionShape2D.disabled = true
		$MainCamera.current = false
		$Health.visible = false
		$AnimatedSprite.stop()
		if (!isTweened):
			var animSpr = $AnimatedSprite
			$Tween.interpolate_property(animSpr, "modulate", animSpr.modulate, Color(animSpr.modulate.r,animSpr.modulate.g,animSpr.modulate.b,0), 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			$Tween.start()
			isTweened = true
	else:
		$MainCamera.current = true
	
	healthBar.value = health/1.5
	#print (health)
	if health <= 0:
		get_node("/root/Base/TimerNode")._gameOver()
	
	var up  = Input.is_action_pressed("ui_up")
	var down  = Input.is_action_pressed("ui_down")
	var left  = Input.is_action_pressed("ui_left")
	var right  = Input.is_action_pressed("ui_right")
	#left = false
	#right = false
	
	var dash = Input.is_action_just_pressed("ui_dash")
	
	#$Sword.isAttack = Input.is_action_pressed("ui_attack")

	if up || down || left || right:
		if up:
			velocity.x = 0
			velocity.y = -SPEED 
			anim.play("walkUp")
			#$Sword.dir = "Up"
			dir = UP
		elif down:
			velocity.x = 0
			velocity.y = SPEED
			anim.play("walkDown")
			#$Sword.dir = "Down"
			dir = DOWN
		elif left:
			velocity.x = -SPEED
			velocity.y = 0
			anim.play("walkLeft")
			#$Sword.dir = "Left"
			dir = LEFT
		elif right:
			velocity.x = SPEED
			velocity.y = 0
			anim.play("walkRight")
			#$Sword.dir = "Right"
			dir = RIGHT
		isIdleAnimPlaying = false
	else:
		velocity = Vector2(0, 0)
		#anim.stop()
		#anim.frame = 0
		#print (dir)
		match dir:
			DOWN:
				anim_stop()
				if !(anim.playing):
					anim.play("idleDown")
					isIdleAnimPlaying = true
			UP:
				anim_stop()
				if !(anim.playing):
					anim.play("idleUp")
					isIdleAnimPlaying = true
			LEFT:
				anim_stop()
				if !(anim.playing):
					anim.play("idleLeft")
					isIdleAnimPlaying = true
			RIGHT:
				anim_stop()
				if !(anim.playing):
					anim.play("idleRight")
					isIdleAnimPlaying = true
							
	if dash && !(isClone):
		match dir:
			UP:
				velocity.y = -SPEED * 20
				velocity.x = 0
			DOWN:
				velocity.y = SPEED *20
				velocity.x = 0
			LEFT:
				velocity.y = 0
				velocity.x = -SPEED * 20
			RIGHT:
				velocity.y = 0
				velocity.x = SPEED * 20
		
		$CollisionShape2D.disabled = true
		#print (velocity * delta)
		print (position)
		move_and_collide(velocity * delta)
		dash_sprites()
		print (position)
		health -= 10
		
		velocity.y = 0
		velocity.x = 0
		
		$CollisionShape2D.disabled = false
		
	move_and_collide(velocity * delta)
	
	
func _on_hit():
	health -= 10
	
func anim_stop():
	if (anim.playing && !isIdleAnimPlaying):
		anim.stop()
		
func dash_sprites():
	var newP = load("res://Scenes/Player.tscn").instance()
	newP.isClone = true
	newP.isTweened = false
	match dir:
		UP:
			newP.position.x = position.x
			newP.position.y = position.y + 10
			#print (position)
			#print (newP.position)
		DOWN:
			newP.position.x = position.x 
			newP.position.y = position.y - 10
		LEFT:
			newP.position.x = position.x + 10
			newP.position.y = position.y
		RIGHT:
			newP.position.x = position.x - 10
			newP.position.y = position.y
	get_node("/root/Base").add_child(newP)

func _on_Tween_tween_completed(object, key):
	queue_free()
