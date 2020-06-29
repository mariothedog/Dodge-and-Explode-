tool
extends Node

# Preload resources
var enemy_scene = preload("res://Enemies/Enemy.tscn")

# Get nodes in the scene
onready var walls = get_node("Walls")
onready var enemies = get_node("Enemies")
onready var player = get_node("Player")

# Export variables
export (int) var width = 400 setget set_width
export (int) var height = 400 setget set_height
export (float) var collision_offset = 8 setget set_collision_offset

# Constant variables
const enemy_spawn_offset = 50

func _ready():
	randomize()

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

func _on_Spawn_Enemy_timeout():
	var enemy_instance = enemy_scene.instance()
	
	var wall = walls.get_child(Util.rand_int(0, 4))
	
	var pos_x = rand_range(wall.position.x - wall.shape.extents.x, wall.position.x + wall.shape.extents.x)
	var pos_y = rand_range(wall.position.y - wall.shape.extents.y, wall.position.y + wall.shape.extents.y)
	var pos = Vector2(pos_x, pos_y)
	var dir_to_player = pos.direction_to(player.position)
	pos += -dir_to_player * enemy_spawn_offset
	enemy_instance.position = pos
	
	enemy_instance.target_dir = dir_to_player
	
	enemies.add_child(enemy_instance)
