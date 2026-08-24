extends Node
class_name Ground_Movement_Controller

###################################

@export var player: Player
@export var input_handler: Input_Handler

###################################

var walk_speed: float = 5.0
var sprint_speed: float = 8.0
var crouch_speed: float = 2.5

var jump_velocity: float = 5.0

const GRAVITY: float = 9.8

var crouching: bool = false
var crouch: bool = false

###################################

var Globaldirection: Vector3
var Globalspeed: float

###################################

func _physics_process(delta: float) -> void:
	crouch_detector()
	
	var label_8: Label = %Label8
	var label_9: Label = %Label9

	Globaldirection = input_handler.direction
	Globalspeed = input_handler.speed

	if player.is_on_floor():
		if Globaldirection: 
			if crouching:
				Globalspeed = lerpf(Globalspeed, crouch_speed, delta * 5)

			else:

				if Input.is_action_pressed("movement_sprint"): 
					Globalspeed = lerpf(Globalspeed, sprint_speed, delta * 5)
				else: 
					Globalspeed = lerpf(Globalspeed, walk_speed, delta * 5)

				if Input.is_action_just_pressed("movement_jump"):
					player.velocity.y = jump_velocity

			player.velocity.x = Globaldirection.x * Globalspeed
			player.velocity.z = Globaldirection.z * Globalspeed

		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, delta * 5)
			player.velocity.z = lerp(player.velocity.z, 0.0, delta * 5)

	elif not player.is_on_floor():
		player.velocity.y -= GRAVITY * delta
		player.velocity.x = lerp(player.velocity.x, Globaldirection.x * Globalspeed, delta * 1.5)
		player.velocity.z = lerp(player.velocity.z, Globaldirection.z * Globalspeed, delta * 1.5)

	label_8.text = str(crouching)
	label_9.text = str(Globalspeed)


func crouch_detector():
	if Input.is_action_just_pressed("movement_crouch-toggle"):
		crouch = ! crouch
	if Input.is_action_pressed("movement_crouch") or crouch:
		crouching = true
	elif ! Input.is_action_pressed("movement_crouch") and ! crouch:
		crouching = false
	
