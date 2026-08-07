extends Node
class_name Air_Movement_Controller

###################################

@export var player: Player

###################################

const GRAVITY: float = 9.8

var jump_velocity: float = 5.0

###################################

func _physics_process(delta: float) -> void:

	if not player.is_on_floor():
		player.velocity.y -= GRAVITY * delta

	if player.is_on_floor() and not Input.is_action_pressed("movement_crouch"):
		if Input.is_action_just_pressed("movement_jump"):
			player.velocity.y = jump_velocity
