extends Node3D

signal open_shop()
@onready var screen_on: CSGBox3D = $laptop_debug_model/laptop_debug_model/hinge/screen_body/screen_on

func _ready() -> void:
	screen_on.hide()

func _on_interaction_col_activate() -> void:
	screen_on.show()
	open_shop.emit()
