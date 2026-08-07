extends Interactable

enum Item_Type{
	debug,
	lootable,
	pickable,
	pushable,
	usable,
	collectable,
	inspectable
}

@export var item_type: Item_Type
@export var inspection_data: Inspection_Data

###################################

func _on_collected(_body: Variant) -> void:
	if item_type == Item_Type.lootable or item_type == Item_Type.collectable:
		set_collision_layer_value(3, false)
		queue_free()

###################################

func _on_picked_up(_body: Variant) -> void:
	if item_type < Item_Type.pushable:
		var hand: Marker3D = get_tree().get_first_node_in_group("hand")
		var target_pos: Vector3 = hand.global_transform.origin
		var object_pos: Vector3 = global_transform.origin
		var object_dis: Vector3 = target_pos - object_pos
		linear_velocity = object_dis/mass * 20
		_hold()

		if ! Input.is_action_pressed("item_pickup"):
			_dropped()

func _on_holding(_body: Variant) -> void:
	_hold()

func _hold():
# doesnt interact with player body, when holding
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)

###################################

func _on_threw(_body: Variant) -> void:
	var target: Marker3D = get_tree().get_first_node_in_group("target")
	var target_pos: Vector3 = target.global_transform.origin
	var object_pos: Vector3 = global_transform.origin
	var object_dis: Vector3 = target_pos - object_pos
	linear_velocity = object_dis / mass/2
	_dropped()

func _dropped():
# resets collision layer
	set_collision_layer_value(3, true)
	set_collision_layer_value(4, false)

func _on_dropped(_body: Variant) -> void:
	_dropped()

###################################

func _on_inspect(_body: Variant) -> void:
	pass # Replace with function body.


func _on_used(_body: Variant) -> void:
	pass # Replace with function body.
