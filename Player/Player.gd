extends KinematicBody2D

const SPEED = 400

var velocity = Vector2()

func _unhandled_input(_event):
	var input_vel = Vector2()
	if Input.is_action_pressed("move_left"):
		input_vel.x -= 1
	if Input.is_action_pressed("move_right"):
		input_vel.x += 1
	if Input.is_action_pressed("move_up"):
		input_vel.y -= 1
	if Input.is_action_pressed("move_down"):
		input_vel.y += 1
	velocity = input_vel.normalized() * SPEED

func _physics_process(_delta):
	velocity = move_and_slide(velocity)
