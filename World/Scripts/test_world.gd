extends Node3D

@onready var inspect_window: CanvasLayer = $Control/inspect_window
@onready var pause_menu: CanvasLayer = $Control/pause_menu

@onready var shop: CanvasLayer = $Control/shop

func _ready() -> void:
	shop.hide()

func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("item_inspect"):
		toggle_inspect_mode()

func toggle_inspect_mode():
	inspect_window.visible = ! inspect_window.visible

func _on_laptop_open_shop() -> void:
	shop.visible = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
