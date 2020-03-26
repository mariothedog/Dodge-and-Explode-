extends KinematicBody2D

const SPEED = 300

var velocity = Vector2()

var target_dir

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)
	
	if target_dir:
		velocity = target_dir * SPEED

func _physics_process(_delta):
	movement()

func movement():
	velocity = move_and_slide(velocity)
	
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		if collision.collider.name == "TileMap":
			die()
		else:
			# Player
			collision.collider.die()

func set_target_dir(target_pos):
	target_dir = position.direction_to(target_pos)

func _on_Tile_Collision_Enabler_body_exited(_body):
	$CollisionShape2D.set_deferred("disabled", false)

func die():
	velocity = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	
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
