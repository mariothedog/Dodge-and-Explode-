extends Node

var screen_shake_enabled = true

func rand_int(minimum, maximum): # Does not include the maximum value.
	return randi() % maximum + minimum
