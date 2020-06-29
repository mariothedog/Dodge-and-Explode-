extends Node

func rand_int(minimum, maximum):
	return randi() % (maximum - minimum) + minimum
