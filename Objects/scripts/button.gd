extends Interactable

signal pressed
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var label: Label = $SubViewport/Label

@export var button_name: String

func _ready() -> void:
	sprite_3d.hide()
	label.text = str(button_name)

func _on_collected(_body: Variant) -> void:
	var pressed_: bool = false
	if ! animation_player.is_playing() and ! pressed_:
		pressed.emit()
		animation_player.play("button_press")
		await animation_player.animation_finished
		pressed_ = false
		if animation_player.is_playing():
			return

func _on_inspect(look: Variant) -> void:
	if look:
		sprite_3d.show()
	else:
		sprite_3d.hide()
