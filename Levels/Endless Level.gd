extends Node2D

var enemy_scene = preload("res://Enemies/Enemy.tscn")

func _ready():
	randomize()

func _on_Spawn_Enemy_timeout():
	var enemy = enemy_scene.instance()
	enemy.position = get_random_position_outside_level()
	enemy.set_target_dir($Player.position)
	$Enemies.add_child(enemy)

func get_random_position_outside_level():
	var pos_x
	var pos_y
	
	match global.rand_int(0, 4):
		0:
			# Left
			pos_x = $"Corners/Top Left".position.x
			pos_y = rand_range($"Corners/Top Left".position.y, $"Corners/Bottom Left".position.y)
		1:
			# Right
			pos_x = $"Corners/Top Right".position.x
			pos_y = rand_range($"Corners/Top Left".position.y, $"Corners/Bottom Left".position.y)
		2:
			# Top
			pos_x = rand_range($"Corners/Top Left".position.x, $"Corners/Top Right".position.x)
			pos_y = $"Corners/Top Left".position.y
		3:
			# Bottom
			pos_x = rand_range($"Corners/Top Left".position.x, $"Corners/Top Right".position.x)
			pos_y = $"Corners/Bottom Left".position.y
	
	var pos = Vector2(pos_x, pos_y)
	pos *= 1.1 # So the enemies spawn out of the player's visible area.
	return pos
