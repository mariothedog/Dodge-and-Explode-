extends KinematicBody2D

# Signals
signal slow_mo_enabled
signal slow_mo_disabled

# Movement constants
const SPEED = 350

# Main variables
var dead = false

# Movement variables
var velocity = Vector2()

# Slow-mo constants
const END_SPEED = 1

# Slow-mo variables
var slow_mo_enabled = false
var slow_mo_fade_out = false
var time_start
var fade_duration_ms
var start_speed

func _ready():
	Engine.time_scale = 1

func _physics_process(_delta):
	get_input()
	if not dead:
		movement()

func get_input():
	var input_vel = Vector2()
	
	if Input.is_action_pressed("move_right"):
		input_vel.x += 1
	if Input.is_action_pressed("move_left"):
		input_vel.x -= 1
	if Input.is_action_pressed("move_up"):
		input_vel.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vel.y += 1
	
	velocity = input_vel.normalized() * SPEED

func movement():
	velocity = move_and_slide(velocity)

func die():
	if not dead:
		dead = true
		
		velocity = Vector2.ZERO
		
		$CollisionShape2D.set_deferred("disabled", true)
		$"Slow-mo Activator/CollisionShape2D".set_deferred("disabled", true)
		
		play_death_animation()
		
		yield($Tween, "tween_all_completed")
		if get_tree().reload_current_scene() != OK:
			print_debug("An error occured while reloading the current scene.")

func play_death_animation():
	for segment in $Body.get_children():
		var segment_dir = (segment.rect_position + segment.rect_pivot_offset).normalized()
		
		segment_dir = segment_dir.rotated(deg2rad(rand_range(0, 45))) # To add some variation to the segment movement.
		
		var final_pos = segment.rect_position + segment_dir * 40
		$Tween.interpolate_property(segment, "rect_position", segment.rect_position, final_pos, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.start()
		
		$Tween.interpolate_property(segment, "color", Color(0, 0, 0, 1), Color(0, 0, 0, 0), 0.5)
		$Tween.start()

func _on_Slowmo_Activator_body_entered(_body):
	start_slow_mo()

func _on_Slowmo_Activator_body_exited(_body):
	stop_slow_mo()

func _process(_delta):
	if slow_mo_fade_out:
		var current_time = OS.get_ticks_msec() - time_start
		var time_scale = circ_ease_in(current_time, start_speed, END_SPEED, fade_duration_ms)
		if current_time >= fade_duration_ms:
			slow_mo_fade_out = false
			slow_mo_enabled = false
			time_scale = END_SPEED
			emit_signal("slow_mo_disabled")
		Engine.time_scale = time_scale

func start_slow_mo(start_strength = 0.9):
	start_speed = 1 - start_strength
	Engine.time_scale = start_speed
	slow_mo_enabled = true
	emit_signal("slow_mo_enabled")

func stop_slow_mo(fade_duration = 0.4):
	time_start = OS.get_ticks_msec()
	fade_duration_ms = fade_duration * 1000
	slow_mo_fade_out = true

func circ_ease_in(t, b, c, d):
	t /= d
	return -c * (sqrt(1 - t * t) - 1 ) + b
