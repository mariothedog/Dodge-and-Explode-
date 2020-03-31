extends Control

func _ready():
	visible = false
	
	$"ColorRect/Screen Shake".pressed = global.screen_shake_enabled

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func pause():
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_Screen_Shake_toggled(button_pressed):
	global.screen_shake_enabled = button_pressed
