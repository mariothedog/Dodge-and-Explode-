extends Node2D

var enemy_scene = preload("res://Enemies/Enemy.tscn")

func _on_Spawn_Enemy_timeout():
	var enemy = enemy_scene.instance()
	enemy.position = get_random_position_outside_level()
	$Enemies.add_child(enemy)

func get_random_position_outside_level():
	var pos_x = rand_range($"Corners/Top Left".position.x - 32, $"Corners/Top Right".position.x + 32)
	var pos_y = rand_range($"Corners/Top Left".position.y, $"Corners/Bottom Left".position.y)
	
	if pos_x > $"Corners/Top Left".position.x and pos_x < $"Corners/Top Right".position.x:
		if pos_y < 0:
			pos_y = rand_range($"Corners/Top Left".position.y, $"Corners/Top Left".position.y - 32)
		elif pos_y > 0:
			pos_y = rand_range($"Corners/Bottom Left".position.y, $"Corners/Bottom Left".position.y + 32)
	
	var pos = Vector2(pos_x, pos_y)
	pos *= 1.1 # So the enemies spawn out of the player's visible area.
	return pos
