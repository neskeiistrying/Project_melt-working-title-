extends Node
class_name Input_Handler

###################################

@export var player: Player

###################################

var input_vector: Vector2
var direction: Vector3

#var alt_direction: Vector3

var speed: float
var vx: float
var vz: float

###################################

func _physics_process(_delta: float) -> void:

# handle user input
	input_vector = Input.get_vector("movement_strafe-left", "movement_strafe-right", "movement_forward", "movement_backward")
	direction = (player.transform.basis * Vector3(input_vector.x, 0, input_vector.y)).normalized()

	#alt_direction = (Global.player.transform.basis * Vector3(0,0,-1)).normalized()

	vx = player.velocity.x * player.velocity.x
	vz = player.velocity.z * player.velocity.z
	speed = sqrt(vx + vz)
