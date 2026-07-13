extends Interactable_RB
class_name Pickable

###################################

# debug
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
var num: int = 0

###################################

func _on_dropped(_body: Variant) -> void:
	_dropped()

func _dropped():
# resets collision layer
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, false)

###################################

func _on_holding(_body: Variant) -> void:
	_hold()

func _hold():
# doesnt interact with player _body, when holding
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)

###################################

func _on_picked_up(_body: Variant) -> void:
	var hand: Marker3D = get_tree().get_first_node_in_group("hand")
	var target_pos: Vector3 = hand.global_transform.origin
	var object_pos: Vector3 = global_transform.origin
	var object_dis: Vector3 = target_pos - object_pos
	linear_velocity = object_dis/mass * 20
	_hold()

###################################

func _on_threw(_body: Variant) -> void:
	var target: Marker3D = get_tree().get_first_node_in_group("target")
	var target_pos: Vector3 = target.global_transform.origin
	var object_pos: Vector3 = global_transform.origin
	var object_dis: Vector3 = target_pos - object_pos
	linear_velocity = object_dis / mass/2
	_dropped()

###################################

func _on_used(_body: Variant) -> void:
	if num > 5:
		num = 0

	num += 1
	var mod: float = num % 2
	if mod == 0:
		pass
	if mod != 0:
		pass

###################################

func _on_inspect(_body: Variant) -> void:
	pass

###################################
