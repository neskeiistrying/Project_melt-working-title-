extends Interactable

signal pressed
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_collected(_body: Variant) -> void:
	var pressed_: bool = false
	pressed.emit()
	if ! animation_player.is_playing() and ! pressed_:
		animation_player.play("button_press")
		await animation_player.animation_finished
		pressed_ = false
		if animation_player.is_playing():
			return
