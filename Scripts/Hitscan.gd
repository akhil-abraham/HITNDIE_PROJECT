extends Area2D

var isScan

func scan(var dir):
	$AnimationPlayer.play(dir)
	

func _on_Hitscan_body_entered( body ):
	isScan = true
