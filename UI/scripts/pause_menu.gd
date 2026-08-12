extends CanvasLayer

@onready var shop: CanvasLayer = $"../shop"

func _ready() -> void:
	visible = false
	get_tree().paused = false

func _on_resume_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	visible = false

func _on_resume_UI() -> void:
	get_tree().paused = false
	visible = false

func _on_pause_pressed() -> void:
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	visible = true

func _unhandled_input(event: InputEvent) -> void:
	if ! shop.visible:
		if event.is_action_pressed("general_back") and get_tree().paused:
			_on_resume_pressed()
		elif event.is_action_pressed("general_back") and ! get_tree().paused:
			_on_pause_pressed()
	if shop.visible:
		if event.is_action_pressed("general_back") and get_tree().paused:
			_on_resume_UI()
		elif event.is_action_pressed("general_back") and ! get_tree().paused:
			_on_pause_pressed()

	if event.is_action_pressed("debug_quit"):
		get_tree().quit()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
