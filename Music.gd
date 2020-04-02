extends Node2D

func _ready():
	$AudioStreamPlayer.volume_db = global.music_volume - 80
	fade_in()

func fade_in():
	$Tween.interpolate_property($AudioStreamPlayer, "volume_db", global.music_volume - 80, global.music_volume - 40,
	2.0, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()

func _process(_delta):
	$AudioStreamPlayer.volume_db = global.music_volume - 40
