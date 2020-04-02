extends Node

var screen_shake_enabled = true
var audio_enabled = true
var music_volume = 0
var audio_volume = 0

func rand_int(minimum, maximum): # Does not include the maximum value.
	return randi() % maximum + minimum
