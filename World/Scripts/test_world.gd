extends Node3D

@onready var inspect_window: CanvasLayer = $Control/inspect_window
@onready var pause_menu: CanvasLayer = $Control/pause_menu

func _unhandled_input(event: InputEvent) -> void:

	if event.is_action_pressed("debug_quit"):
		get_tree().quit()

	if event.is_action_pressed("general_back"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		pause_menu.visible = true
		get_tree().paused = true

	if event.is_action_pressed("item_inspect"):
		toggle_inspect_mode()

func toggle_inspect_mode():
	inspect_window.visible = ! inspect_window.visible
