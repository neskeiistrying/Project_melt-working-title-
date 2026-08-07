extends Node
class_name Ground_Movement_Controller

###################################

@export var player: Player
@export var input_handler: Input_Handler

###################################

var walk_speed: float = 7.0
var sprint_speed: float = 11.0
var crouch_speed: float = 3.0

#var Globalstate: String

###################################

var Globaldirection: Vector3
var Globalspeed: float

###################################

func _physics_process(delta: float) -> void:

	Globaldirection = input_handler.direction
	Globalspeed = input_handler.speed

	if player.is_on_floor():
		if Globaldirection: 
			if Input.is_action_pressed("movement_crouch"):
				Globalspeed = lerp(Globalspeed, crouch_speed, delta * lerp(0.0, 5.0, delta * 30))
			elif Input.is_action_pressed("movement_sprint"): 
				Globalspeed = lerp(Globalspeed, sprint_speed, delta * lerp(0.0, 5.0, delta * 30))
			else: 
				Globalspeed = lerp(Globalspeed, walk_speed, delta * lerp(0.0, 5.0, delta * 30))

			player.velocity.x = Globaldirection.x * Globalspeed
			player.velocity.z = Globaldirection.z * Globalspeed

		else:
			player.velocity.x = lerp(player.velocity.x, 0.0, delta * 5)
			player.velocity.z = lerp(player.velocity.z, 0.0, delta * 5)
