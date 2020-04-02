extends Control

func _on_Start_pressed():
	if get_tree().change_scene("res://Levels/Endless Level.tscn") != OK:
		print_debug("An error occured while changing to the endless level scene.")
