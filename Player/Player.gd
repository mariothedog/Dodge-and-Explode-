extends KinematicBody2D

# Get nodes in the scene
onready var sprite = get_node("Sprite")
onready var collision_shape = get_node("CollisionShape2D")
onready var animation_player = get_node("AnimationPlayer")
onready var dash_duration_timer = get_node("Dash Duration Timer")
onready var can_kill_duration_timer = get_node("Can Kill Duration Timer")
onready var slowmo_collision_shape = get_node("Slow-mo Activator/CollisionShape2D")

# Constant variables
const SPEED = 400
const DASH_SPEED = 2000
const DASH_DURATION = 0.05
const CAN_KILL_DURATION = 0.15 # To give some leniency if the player hits an enemy just after the dash ends

# Variables
var velocity = Vector2()
var input_vel = Vector2()
var dead = false
var currently_dashing = false
var can_kill = false

func _physics_process(_delta) -> void:
	get_input()
	move()
	animate()

func get_input() -> void:
	if dead:
		return
	
	input_vel = Vector2()
	
	if Input.is_action_just_pressed("dash"):
		currently_dashing = true
		dash_duration_timer.start(DASH_DURATION)
		can_kill = true
		can_kill_duration_timer.start(CAN_KILL_DURATION)
	
	input_vel.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vel.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if currently_dashing:
		if input_vel == Vector2.ZERO:
			velocity = velocity.normalized() * DASH_SPEED
		else:
			velocity = input_vel.normalized() * DASH_SPEED
	else:
		velocity = input_vel.normalized() * SPEED

func _on_Dash_Duration_Timer_timeout() -> void:
	currently_dashing = false

func _on_Can_Kill_Duration_Timer_timeout() -> void:
	can_kill = false

func move() -> void:
	velocity = move_and_slide(velocity)

func animate() -> void:
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

func die() -> void:
	collision_shape.set_deferred("disabled", true)
	slowmo_collision_shape.set_deferred("disabled", true)
	Slowmo.stop()
	dead = true
	velocity = Vector2.ZERO
	
	animation_player.play("Die") # TODO
	
	yield(animation_player, "animation_finished")
	
	if get_tree().reload_current_scene() != OK:
		print_debug("An error occurred while reloading the scene.")

func _on_Slowmo_Activator_area_entered(_area):
	Slowmo.start()

func _on_Slowmo_Activator_area_exited(_area):
	Slowmo.stop()
