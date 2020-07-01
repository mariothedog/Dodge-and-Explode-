extends KinematicBody2D

# Get nodes in the scene
onready var sprite = get_node("Sprite")
onready var collision_shape = get_node("CollisionShape2D")
onready var animation_player = get_node("AnimationPlayer")
onready var dash_duration_timer = get_node("Dash Duration Timer")
onready var can_kill_duration_timer = get_node("Can Kill Duration Timer")

# Constant variables
const SPEED = 400
const DASH_SPEED = 2000
const DASH_DURATION = 0.05
const CAN_KILL_DURATION = 0.15

# Variables
var velocity = Vector2()
var input_vel = Vector2()
var dead = false
var currently_dashing = false
var can_kill = false

func _physics_process(_delta):
	get_input()
	move()
	animate()

func get_input():
	if dead:
		return
	
	input_vel = Vector2()
	
	if Input.is_action_just_pressed("dash"):
		currently_dashing = true
		dash_duration_timer.start(DASH_DURATION)
		can_kill = true
		can_kill_duration_timer.start(CAN_KILL_DURATION)
	
	if currently_dashing:
		velocity = velocity.normalized() * DASH_SPEED
		return
	
	input_vel.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vel.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = input_vel.normalized() * SPEED

func _on_Dash_Duration_Timer_timeout():
	currently_dashing = false

func _on_Can_Kill_Duration_Timer_timeout():
	can_kill = false

func move():
	velocity = move_and_slide(velocity)

func animate():
	if input_vel != Vector2.ZERO:
		sprite.rotation = input_vel.angle() + PI/2
	
	if dead:
		return
	
	if abs(velocity.length()) > 1:
		if can_kill:
			animation_player.play("Dash") # TODO
		else:
			animation_player.play("Run") # TODO
	else:
		animation_player.play("Idle") # TODO

func die():
	collision_shape.set_deferred("disabled", true)
	dead = true
	velocity = Vector2.ZERO
	
	animation_player.play("Die") # TODO
	
	yield(animation_player, "animation_finished")
	
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while reloading the scene.")
