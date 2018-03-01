extends Node2D

signal hit

var isAttack
var isAnim

var dir

func _ready():
	isAttack = false
	isAnim = false
	$AnimationPlayer.connect("animation_finished", self, "animFinished")
	set_process(true)

func _process(delta):
	#print (isAttack)
	if (get_parent().name == "Player"):
		$AnimationPlayer.playback_speed = 3
	else:
		$AnimationPlayer.playback_speed = .5
	
	match dir:
		"Up":
			rotation_degrees = 0
		"Down":
			rotation_degrees = 180
		"Left":
			rotation_degrees = -90
		"Right":
			rotation_degrees = 90
	
	if isAttack && !isAnim:
		match dir:
			"Up":
				$AnimationPlayer.play("SwordUp")
			"Down":
				$AnimationPlayer.play("SwordDown")
			"Left":
				$AnimationPlayer.play("SwordLeft")
			"Right":
				$AnimationPlayer.play("SwordRight")
		isAnim = true
		
		
		
func animFinished(animName):
	isAnim = false
	#isAttack = false
	#print ("hiya")
	

func _on_Sword_body_entered(body):
	#emit_signal("hit", body.get_name())
	if !(body.get_name() == get_parent().get_name()) && body.is_in_group("Entities"):
		if (body.get_name() == "Player"):
			if !(body.isClone == true):
				get_node("/root/Base/" + body.get_name())._on_hit()
		else:
			var e_name = body.get_name()
			get_node("/root/Base/" + e_name)._on_hit()
