extends Interactable_SB
class_name Usable

###################################

func _on_collected(_body: Variant) -> void:
	if collectable:
		set_collision_layer_value(3, false)
		queue_free()
	else:
		pass

###################################

func _on_used(_body: Variant) -> void:
	pass # Replace with function body.

###################################

func _on_inspect(_body: Variant) -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if collectable:
		prompt_l1 = "collectable"
	else:
		prompt_l1 = " not collectable"
