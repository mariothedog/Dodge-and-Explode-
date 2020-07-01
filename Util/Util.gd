extends Node

func rand_int(minimum : int, maximum : int) -> int:
	return randi() % (maximum - minimum) + minimum
