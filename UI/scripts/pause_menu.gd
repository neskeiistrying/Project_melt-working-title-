extends CanvasLayer

func _ready() -> void:
	visible = false
	get_tree().paused = false

func _on_resume_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
