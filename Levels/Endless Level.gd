extends Node2D

var enemy_scene = preload("res://Enemies/Enemy.tscn")

func _ready():
	randomize()
	
	$"Visual Effect".material.set_shader_param("slow_mo", false)

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

func _on_Player_slow_mo_enabled():
	$"Visual Effect".material.set_shader_param("slow_mo", true)

func _on_Player_slow_mo_disabled():
	$"Visual Effect".material.set_shader_param("slow_mo", false)

func _process(_delta):
	if $Player.slow_mo_enabled:
		# When the time scale is 0.1 the blur_amount/chromatic_amount will be 0.5.
		# When the time_scale is 1 the blur_amount/chromatic_amount will be 0.
		var amount = -5.0/9.0 * Engine.time_scale + 5.0/9.0
		$"Visual Effect".material.set_shader_param("blur_amount", amount)
		
		$"Visual Effect".material.set_shader_param("chromatic_amount", amount)
		
		# When the time_scale is 1 the darkness_multi will also be 1.
		# When the time_scale is 0.1 the darkness_multi will be 0.8.
		var darkness_multi = 2.0/9.0 * Engine.time_scale + 7.0/9.0
		$"Visual Effect".material.set_shader_param("darkness_multi", darkness_multi)
