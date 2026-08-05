extends Interactable_RB
class_name lootable

###################################

# debug
#@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
#@onready var mesh_instance_3d_2: MeshInstance3D = $MeshInstance3D2
var num: int = 0

@export var slot_data: Slot_Data

###################################

func _on_collected(body: Variant) -> void:
	if body.inventory_data.pick_up_slot_data(slot_data):
		set_collision_layer_value(3, false)
		queue_free()

###################################

func _on_holding(_body: Variant) -> void:
	_hold()

func _hold():
# doesnt interact with player body, when holding
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)

###################################

func _on_dropped(_body: Variant) -> void:
	_dropped()

func _dropped():
# resets collision layer
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, false)

###################################

func _on_picked_up(_body: Variant) -> void:
	var hand: Marker3D = get_tree().get_first_node_in_group("hand")
	var target_pos: Vector3 = hand.global_transform.origin
	var object_pos: Vector3 = global_transform.origin
	var object_dis: Vector3 = target_pos - object_pos
	linear_velocity = object_dis/mass * 20
	_hold()

	if ! Input.is_action_pressed("item_pickup"):
		_dropped()

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
		return
		#mesh_instance_3d.hide()
		#mesh_instance_3d_2.show()
	if mod != 0:
		return
		#mesh_instance_3d_2.hide()
		#mesh_instance_3d.show()

###################################

func _on_inspect(_body: Variant) -> void:
	pass

###################################
