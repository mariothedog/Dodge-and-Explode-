tool
extends Node

export (int) var width = 400 setget set_width
export (int) var height = 400 setget set_height
export (float) var collision_offset = 8 setget set_collision_offset

func set_width(w):
	width = w
	update_size()

func set_height(h):
	height = h
	update_size()

func set_collision_offset(o):
	collision_offset = o
	update_size()

func update_size():
	if not has_node("Play Area"):
		return
	
	var play_area = get_node("Play Area")
	var size = Vector2(width, height)
	play_area.rect_size = size
	play_area.rect_position = -size / 2
	
	var top_wall = get_node("Walls/Top")
	var bottom_wall = get_node("Walls/Bottom")
	var right_wall = get_node("Walls/Right")
	var left_wall = get_node("Walls/Left")
	
	# The top and bottom, and right and left walls share the same shape so only one of their extents needs to be modified
	top_wall.shape.extents.x = width / 2
	right_wall.shape.extents.y = height / 2
	
	top_wall.position.y = -height / 2 - collision_offset
	bottom_wall.position.y = height / 2 + collision_offset
	
	left_wall.position.x = -width / 2 - collision_offset
	right_wall.position.x = width / 2 + collision_offset
