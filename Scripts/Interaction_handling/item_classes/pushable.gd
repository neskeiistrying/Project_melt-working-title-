extends Interactable_RB
class_name Pushable

###################################

# debug
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
var num: int = 0

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
	pass # Replace with function _body.

###################################
