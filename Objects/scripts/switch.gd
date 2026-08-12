extends Interactable
class_name Switch

signal toggled()
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var csg_box_3d: CSGBox3D = $button_model/CSGBox3D/CSGBox3D

var toggled_on: bool = false

func _on_collected(_body: Variant) -> void:
	if ! animation_player.is_playing():
		if ! toggled_on: 
			toggled_on = true
			animation_player.play("switch_toggle_on")
			await animation_player.animation_finished
			csg_box_3d.show()
			toggled.emit()
		else: 
			toggled_on = false
			animation_player.play("switch_toggle_off")
			csg_box_3d.hide()
				

func toggle_off():
	if toggled_on:
		toggled_on = false
		animation_player.play("switch_toggle_off")
		csg_box_3d.hide()
