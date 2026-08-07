extends CanvasLayer

@onready var description: Label = %description
@onready var object_name: Label = %object_name
@onready var texture_rect: TextureRect = %TextureRect

func _ready() -> void:
	visible = false

func _on_player_inspect_this(data: Variant) -> void:
	if data:
		description.text = data.description
		object_name.text = data.name
		texture_rect.texture = data.texture
