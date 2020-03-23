extends KinematicBody2D

# Movement constants
const SPEED = 300

# Movement variables
var velocity = Vector2()

func _physics_process(_delta):
	get_input()
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
