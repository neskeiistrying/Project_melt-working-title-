extends Node
class_name Camera_FX_Controller

###################################


@export var player: Player
@export var body: MeshInstance3D
@export var collision_shape: CollisionShape3D
@export var camera: Camera3D
@export var input_handler: Input_Handler

###################################

const BOB_FREQ: float = 2.0
const BOB_AMP: float = 0.08

const BASE_FOV: float = 75.0
const FOV_CHANGE: float = 1.5 

var t_bob: float = 0.0

var target_fov: float
var target_fov_tps: float

###################################

var Globalspeed: float
var Globaldirection: Vector3

###################################

func _headbob(time)-> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ/2) * BOB_AMP
	return pos

###################################

func _physics_process(delta: float) -> void:

	Globaldirection = input_handler.direction
	Globalspeed = input_handler.speed

# handle fov change
	var velocity_clamped = clamp(player.velocity.length(), 0.75, Globalspeed * .75)
	target_fov = BASE_FOV + FOV_CHANGE  * velocity_clamped
	target_fov_tps = BASE_FOV + FOV_CHANGE * (velocity_clamped * 0.5)
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)

# handle headbob
	if player.is_on_floor():
		if Globaldirection:
			t_bob += delta * player.velocity.length()/1
			camera.transform.origin = _headbob(t_bob)
