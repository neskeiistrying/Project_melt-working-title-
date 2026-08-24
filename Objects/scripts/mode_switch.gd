extends Interactable

signal processing_mode(data)

@onready var label: Label = $Label
@onready var label_2: Label = $SubViewport/Label2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var sprite_3d: Sprite3D = $Sprite3D

enum mode{
	off,
	safe,
	full
}

var int_num: int = 0

func _ready() -> void:
	sprite_3d.hide()
	switch_fx()

func _on_collected(_body: Variant) -> void:
	if ! animation_player.is_playing():
		int_num += 1
		if int_num > 2 :
			int_num = 0
		switch_fx()
		processing_mode.emit(mode.find_key(int_num))

func switch_fx():
	label_2.text = mode.find_key(int_num)
	match int_num:
		0:
			animation_player.play("full_off")
		1:
			animation_player.play("off_safe")
		2:
			animation_player.play("safe_full")

func _on_inspect(look: Variant) -> void:
	if look:
		sprite_3d.show()
	else:
		sprite_3d.hide()
