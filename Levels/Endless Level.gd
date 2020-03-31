extends Node2D

# Preload resources
var enemy_scene = preload("res://Enemies/Enemy.tscn")

# Signals
signal manually_restarting

# Main variables
const centre = Vector2.ZERO

# Restarting variables
var restarting = false
var player_death_anim_played = false

func _ready():
	Engine.time_scale = 1
	$"Visual Effect".material.set_shader_param("slow_mo", false)
	
	randomize()

func _input(_event):
	if Input.is_action_just_pressed("restart") and not restarting:
		manual_restart()

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
	if restarting:
		if $Player.position == centre or $Player.dead:
			if not player_death_anim_played and not $Player.dead:
				$Player.play_death_animation()
				player_death_anim_played = true
			
			for enemy in $Enemies.get_children():
				if (enemy.position.x < $"Corners/Top Left".position.x - 16 or enemy.position.x > $"Corners/Top Right".position.x + 16 or
				enemy.position.y < $"Corners/Top Left".position.y - 16 or enemy.position.y > $"Corners/Bottom Left".position.y + 16):
					enemy.queue_free()
			
			if $Enemies.get_child_count() == 0 and not $Player/Tween.is_active():
				if get_tree().reload_current_scene() != OK:
					print_debug("An error occurred while reloading the current scene.")
	else:
		# When the time scale is 0.1 the chromatic_amount will be 0.5.
		# When the time_scale is 1 the chromatic_amount will be 0.3.
		var chromatic_amount = -2.0/9.0 * Engine.time_scale + 47.0/90.0
		$"Visual Effect".material.set_shader_param("chromatic_amount", chromatic_amount)
		
		if $Player.slow_mo_enabled:
			# When the time scale is 0.1 the blur_amount will be 0.5.
			# When the time_scale is 1 the blur_amount will be 0.
			var blur_amount = -5.0/9.0 * Engine.time_scale + 5.0/9.0
			$"Visual Effect".material.set_shader_param("blur_amount", blur_amount)
			
			# When the time_scale is 1 the darkness_multi will also be 1.
			# When the time_scale is 0.1 the darkness_multi will be 0.8.
			var darkness_multi = 2.0/9.0 * Engine.time_scale + 7.0/9.0
			$"Visual Effect".material.set_shader_param("darkness_multi", darkness_multi)

func _on_Player_dead():
	if global.screen_shake_enabled:
		$Camera2D.shake(0.4, 70.0, 16.0)
	
	$"Spawn Enemy".stop()
	for enemy in $Enemies.get_children():
		enemy.velocity = Vector2.ZERO

func manual_restart():
	restarting = true
	emit_signal("manually_restarting")
	$"Spawn Enemy".stop()
	
	$Player.disable_collision_shapes()
	$Player.velocity = Vector2.ZERO
	
	for enemy in $Enemies.get_children():
		if enemy.velocity == Vector2.ZERO:
			enemy.velocity = enemy.target_dir * enemy.SPEED
		enemy.velocity *= -1
		enemy.disable_collisions()

func _on_Player_at_centre_after_restarting():
	$Player.velocity = Vector2.ZERO

func _on_Enemy_dead(cause):
	if global.screen_shake_enabled:
		if cause.name == "Player":
			# If the player dashed into the enemy.
			$Camera2D.shake(0.3, 30.0, 12.0)
		else:
			$Camera2D.shake(0.2, 15.0, 8.0)
