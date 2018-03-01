extends Button

var gameScene = "res://Scenes/Game.tscn"

func _on_Button_pressed():
	get_tree().change_scene(gameScene)
