extends Area2D

func _on_Heart_body_entered( body ):
	if (body.get_name() == "Player"):
		if (get_node("/root/Base/Player").health <= get_node("/root/Base/Player").maxHealth - 15):
			get_node("/root/Base/Player").health += 15
		else:
			get_node("/root/Base/Player").health = get_node("/root/Base/Player").maxHealth
		get_node("/root/Base/TimerNode").changeTimer(-5)
		queue_free()
		
