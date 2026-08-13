extends Interactable

var buffer: Array[Interactable_Object]
@onready var sprite_3d: Sprite3D = %Sprite3D

func _ready() -> void:
	sprite_3d.hide()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is Interactable_Object:
		if ! buffer.has(body):
			buffer.append(body)

func _on_inspect(look) -> void:
	if look:
		sprite_3d.show()
	else:
		sprite_3d.hide() 
