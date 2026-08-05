extends Node
class_name Camera_Controller

###################################

@export var player: Player
@export var cam_tilt_pivot: Node3D
@export var camera: Camera3D

var inventory_interface: Control

###################################


var sensitivity: float = 0.005

var capture_mouse: bool
var mouse_input: Vector2

var camera_tilt_low_limit: float = deg_to_rad(-180)
var camera_tilt_high_limit: float = deg_to_rad(180) 


var rotation: Vector3

var player_rot: Vector3
var head_rot: Vector3

###################################

func _unhandled_input(event: InputEvent) -> void:

	capture_mouse = Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and event is InputEventMouseMotion
	if capture_mouse:
		mouse_input.x = -event.screen_relative.x * sensitivity
		mouse_input.y = -event.screen_relative.y * sensitivity

###################################

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

###################################

func _process(_delta: float) -> void:
	mouse_input = Vector2.ZERO

###################################

func update_cam_rotation():
	rotation.x += mouse_input.y
	rotation.y += mouse_input.x
	rotation.x = clamp(rotation.x, camera_tilt_low_limit, camera_tilt_high_limit)
	rotation.z = 0.0
	
	player_rot = Vector3(0.0, rotation.y, 0.0)
	head_rot = Vector3(rotation.x, 0.0, 0.0)

	cam_tilt_pivot.transform.basis = Basis.from_euler(head_rot)
	player.transform.basis = Basis.from_euler(player_rot) 

###################################

func _physics_process(delta: float) -> void:
	update_cam_rotation()

	cam_tilt_pivot.transform.basis = Basis.from_euler(lerp(Vector3.ZERO, head_rot, 45 * delta))
	player.transform.basis = Basis.from_euler(lerp(Vector3.ZERO, player_rot, 45 * delta))
