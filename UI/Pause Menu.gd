extends Control

func _ready():
	visible = false
	
	$"MarginContainer/VBoxContainer/Screen Shake".pressed = global.screen_shake_enabled
	$"MarginContainer/VBoxContainer/Music/Music Slider".value = global.music_volume
	$"MarginContainer/VBoxContainer/Audio/Audio Slider".value = global.audio_volume

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		pause()

func pause():
	get_tree().paused = not get_tree().paused
	visible = not visible

func _on_Screen_Shake_toggled(button_pressed):
	global.screen_shake_enabled = button_pressed

func _on_Music_Slider_value_changed(value):
	global.music_volume = value

func _on_Audio_Slider_value_changed(value):
	global.audio_volume = value
