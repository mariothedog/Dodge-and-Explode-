extends KinematicBody2D

const SPEED = 300

var velocity = Vector2()

var target_dir

func _ready():
	$CollisionShape2D.set_deferred("disabled", true)

func _physics_process(_delta):
	movement()

func movement():
	if target_dir:
		velocity = target_dir * SPEED
	
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
	queue_free()
