extends KinematicBody2D

# Signals
signal dead

# Main variables
var dead = false

# Movement variables
const SPEED = 300

var velocity = Vector2()
var target_dir

func _ready():
	if target_dir:
		velocity = target_dir * SPEED
	
	if connect("dead", get_parent().get_parent().get_node("HUD"), "_on_Enemy_dead") != OK:
		print_debug("An error occured while connecting a signal to a method.")
	
	if connect("dead", get_parent().get_parent(), "_on_Enemy_dead") != OK:
		print_debug("An error occured while connecting a signal to a method.")

func _physics_process(_delta):
	movement()
	ai()

func movement():
	velocity = move_and_slide(velocity)
	
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap":
			die(collision.collider)
		else:
			# Player
			if collision.collider.currently_dashing:
				die(collision.collider)
			else:
				collision.collider.die()

func ai():
	pass

func set_target_dir(target_pos):
	target_dir = position.direction_to(target_pos)

func _on_Tile_Collision_Enabler_body_exited(_body):
	collision_mask = 1

func die(cause):
	if not dead:
		dead = true
		
		if cause.name == "Player":
			cause.increase_combo()
			$"Combo Counter".display(cause.combo)
		
		emit_signal("dead", cause)
		
		velocity = Vector2.ZERO
		$CollisionShape2D.set_deferred("disabled", true)
		
		if global.audio_enabled:
			$"Die SFX".play()
		
		play_death_animation()
		
		yield($Tween, "tween_all_completed")
		var timer = get_tree().create_timer(0.1)
		timer.connect("timeout", self, "queue_free")

func play_death_animation():
	for segment in $Body.get_children():
		var segment_dir = (segment.rect_position + segment.rect_pivot_offset).normalized()
		
		segment_dir = segment_dir.rotated(deg2rad(rand_range(0, 45))) # To add some variation to the segment movement.
		
		var final_pos = segment.rect_position + segment_dir * 40
		$Tween.interpolate_property(segment, "rect_position", segment.rect_position, final_pos, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.start()
		
		$Tween.interpolate_property(segment, "color", Color(1, 0, 0, 1), Color(1, 0, 0, 0), 0.5)
		$Tween.start()

func disable_collisions():
	$CollisionShape2D.set_deferred("disabled", true)
